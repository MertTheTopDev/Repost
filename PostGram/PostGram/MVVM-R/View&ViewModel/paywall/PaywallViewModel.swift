//
//  PaywallViewModel.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import Foundation
import RevenueCat
import Combine

class PaywallViewModel: ObservableObject {

    @Published var selectedPackage: Package?
    
    var cancellables = Set<AnyCancellable>()
    let revenueCatManager: RevenueCatManager
    
    init(revenueCatManager: RevenueCatManager = .shared) {
        self.revenueCatManager = revenueCatManager
        
        revenueCatManager.$offerings
            .receive(on: DispatchQueue.main)
            .sink { [weak self] offerings in
            guard let self = self else { return }
            guard let packages = offerings?.current?.availablePackages else { return }
            
            let consPackage = packages.filter { $0.id == "$rc_weekly"}.first
            guard let selected = consPackage else { return }
            self.selectedPackage = selected
        }.store(in: &cancellables)
        
        checkSubscriptionStatus()
        
        
    }
    
    func makePackage(_ package: Package) -> String {
           
        let storeProduct = package.storeProduct
        let price = NSDecimalNumber(decimal: storeProduct.price)
               
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
               
        let formattedPrice = numberFormatter.string(from: price) ?? "6.99"
        let currencySymbol = storeProduct.localizedPriceString.prefix(1)
               
        let currencyCode = if currencySymbol.contains("AU$") {
            "AUD"
        } else if currencySymbol.contains("CA$") {
            "CAD"
        } else if currencySymbol.contains("HK$") {
            "HKD"
        } else {
            switch currencySymbol {
            case "$": "USD"
            case "€": "EUR"
            case "¥": "JPY"
            case "£": "GBP"
            case "₺": "TRY"
            case "₩": "KRW"
            case "₹": "INR"
            case "₽": "RUB"
            case "₸": "KZT"
            case "₴": "UAH"
            case "฿": "THB"
            case "₡": "CRC"
            case "₪": "ILS"
            case "₱": "PHP"
            case "R$": "BRL"
            case "S/": "PEN"
            case "₫": "VND"
            case "Kč": "CZK"
            case "zł": "PLN"
            case "kr": "SEK"
            case "MX$": "MXN"
            case "SGD$": "SGD"
            case "CHF": "CHF"
            case "DKK": "DKK"
            case "NOK": "NOK"
            case "AED": "AED"
            case "SAR": "SAR"
            case "EGP": "EGP"
            case "ARS": "ARS"
            case "CLP": "CLP"
            case "COP": "COP"
            case "IDR": "IDR"
            case "MYR": "MYR"
            case "NGN": "NGN"
            case "PKR": "PKR"
            case "QAR": "QAR"
            case "TWD": "TWD"
            case "ZAR": "ZAR"
            default: "USD"
            }
        }
               
        return "\(formattedPrice) \(currencyCode)/"
    }
        
    
    
}

extension PaywallViewModel {
    
}

//MARK: - RevenuCat -
extension PaywallViewModel {
    func checkSubscriptionStatus() -> Bool {
        revenueCatManager.checkEntitlement("pro")
    }
    
    
    func purchase(package: Package, result: @escaping (Bool) -> ()) {
        Task {
            do {
                let customerInfo = try await revenueCatManager.purchase(package)
                await MainActor.run {
                    // Check if this specific purchase was successful
                    let premiumIdentifiers = ["pro"]
                    let hasActiveEntitlement = premiumIdentifiers.contains { identifier in
                        customerInfo.entitlements[identifier]?.isActive == true
                    }
                    
                    // Verify purchase wasn't cancelled
                    if customerInfo
                        .entitlements["pro"]?.productIdentifier == package.storeProduct.productIdentifier
                        && hasActiveEntitlement {
                        result(true)
                    } else {
                        result(false)
                    }
                }
            } catch {
                print(
                    "SubViewModel: Purchase failed: \(error.localizedDescription)"
                )
                await MainActor.run {
                    result(false)
                }
            }
        }
    }
    
    func restorePurchases(_ completion: @escaping (Bool) -> ()) {
        Task {
            do {
                let customerInfo = try await revenueCatManager.restorePurchases()
                await MainActor.run {
                    let premiumIdentifiers = [
                        "premium",
                        "premium_access",
                        "pro",
                        "pro_access"
                    ]
                    let isSubscribed = premiumIdentifiers.contains { identifier in
                        customerInfo.entitlements[identifier]?.isActive == true
                    }
                    print("SubViewModel: Restore is \(isSubscribed)")
                    completion(isSubscribed)
                }
            } catch {
                print(
                    "SubViewModel: Restore purchases failed: \(error.localizedDescription)"
                )
                await MainActor.run {
                    completion(false)
                }
            }
        }
    }
}
