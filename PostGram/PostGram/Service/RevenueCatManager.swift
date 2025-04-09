//
//  RevenueCatManager.swift
//  XScanner
//
//  Created by Mert Türedü on 12.12.2024.
//

import RevenueCat
import OSLog

final class RevenueCatManager {
    static let shared = RevenueCatManager()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "RevenueCatManager")
    
    @Published private(set) var offerings: Offerings?
    @Published private(set) var customerInfo: CustomerInfo?
    
    private init() {
        configureRevenueCat()
    }
    
    private func configureRevenueCat() {
        logger.debug("RevenueCatM: 🚀 Configuring RevenueCat...")
        do {
            Purchases.configure(withAPIKey: "appl_MAJKdlGcAmIpBOQCbCqgAPSohMR")
            logger.info("RevenueCatM: ✅ RevenueCat successfully configured")
            
            // Önce customer info'yu al
            Task {
                do {
                    self.customerInfo = try await Purchases.shared.customerInfo()
                    logger.info("RevenueCatM: 📱 Initial customer info fetched")
                } catch {
                    logger.error("RevenueCatM: ❌ Failed to fetch initial customer info: \(error.localizedDescription)")
                }
            }
            
            setupCustomerInfoListener()
            fetchOfferings()
        } catch {
            logger.error("RevenueCatM: ❌ Failed to configure RevenueCat: \(error.localizedDescription)")
        }
    }
    
    private func setupCustomerInfoListener() {
        logger.debug("RevenueCatM: 🔍 Setting up customer info listener")
        Task {
            do {
                for try await customerInfo in Purchases.shared.customerInfoStream {
                    self.customerInfo = customerInfo
                    logger.info("RevenueCatM: 🔄 Customer info updated: \(customerInfo.originalAppUserId)")
                    
                    // Log active entitlements
                    let activeEntitlements = customerInfo.entitlements.active.keys
                    logger.debug("RevenueCatM: 🔑 Active entitlements: \(activeEntitlements.joined(separator: ", "))")
                }
            } catch {
                logger.error("RevenueCatM: ❌ Error in customer info stream: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchOfferings() {
        logger.debug("RevenueCatM: 🛒 Fetching offerings")
        Task {
            do {
                offerings = try await Purchases.shared.offerings()
                guard let offerings = offerings else {
                    logger.warning("RevenueCatM: ⚠️ No offerings found")
                    return
                }
                
                logger.info("RevenueCatM: ✅ Offerings fetched successfully")
                for offer in offerings.all {
                    logger.debug("RevenueCatM: 🏷️ Offer found: \(offer.key) - \(offer.value)")
                }
            } catch {
                logger.error("RevenueCatM: ❌ Failed to fetch offerings: \(error.localizedDescription)")
            }
        }
    }
    
    func purchase(_ package: Package) async throws -> CustomerInfo {
        logger.debug("RevenueCatM: 💳 Attempting to purchase package: \(package.identifier)")
        do {
            let purchaseResult = try await Purchases.shared.purchase(package: package)
            logger.info("RevenueCatM: ✅ Purchase successful for package: \(package.identifier)")
            return purchaseResult.customerInfo
        } catch {
            logger.error("RevenueCatM: ❌ Purchase failed for package \(package.identifier): \(error.localizedDescription)")
            throw error
        }
    }
    
    func restorePurchases() async throws -> CustomerInfo {
        logger.debug("RevenueCatM: 🔄 Restoring purchases")
        do {
            let restoredCustomerInfo = try await Purchases.shared.restorePurchases()
            logger.info("RevenueCatM: ✅ Purchases restored successfully")
            return restoredCustomerInfo
        } catch {
            logger.error("RevenueCatM: ❌ Failed to restore purchases: \(error.localizedDescription)")
            throw error
        }
    }
    
    func checkEntitlement(_ entitlement: String) -> Bool {
        let allEntitlements = customerInfo?.entitlements.all
        logger.debug("RevenueCatM: 🔑 Available entitlements: \(String(describing: allEntitlements))")
        
        // Check both specific entitlement and premium identifiers
        let premiumIdentifiers = ["premium", "premium_access", "pro", "pro_access"]
        let isActive = premiumIdentifiers.contains { identifier in
            customerInfo?.entitlements[identifier]?.isActive == true
        }
        
        logger.debug("RevenueCatM: 🔑 Checking entitlement '\(entitlement)': \(isActive ? "Active" : "Inactive")")
        return isActive
    }
    
    func isSubscribed() -> Bool {
        logger.debug("RevenueCatM: 🔍 Checking subscription status")
        
        // Kullanıcı bilgilerini kontrol et
        guard let customerInfo = customerInfo else {
            logger.warning("RevenueCatM: ⚠️ No customer info available")
            return false
        }
        
        // Tüm aktif entitlement'ları kontrol et
        let activeEntitlements = customerInfo.entitlements.active
        
        // Debug için aktif entitlement'ları logla
        logger.debug("RevenueCatM: 📋 Active entitlements: \(activeEntitlements.keys.joined(separator: ", "))")
        
        // premium_access veya benzer entitlement'ları kontrol et
        let premiumIdentifiers = ["premium", "premium_access", "pro", "premium_user"]
        let isPremium = premiumIdentifiers.contains { identifier in
            activeEntitlements[identifier]?.isActive == true
        }
        
        logger.info("RevenueCatM: 👤 User subscription status: \(isPremium ? "Subscribed ✅" : "Not Subscribed ❌")")
        return isPremium
    }
}
