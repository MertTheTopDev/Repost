//
//  SettingsViewModel.swift
//  PostGram
//
//  Created by Mert Türedü on 7.04.2025.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    
    @Published var isAppearPremium: Bool
    var isPresented: Binding<Bool>
    let revenueCatManager: RevenueCatManager
    
    init( _ isPresented: Binding<Bool>,
         isAppearPremium: Bool = false,
         revenueCatManager: RevenueCatManager = .shared) {
        self.isPresented = isPresented
        self.isAppearPremium = isAppearPremium
        self.revenueCatManager = revenueCatManager
    }
    
    func closeSettings() {
        isPresented.wrappedValue = false
    }
    
}

extension SettingsViewModel {

    func makeNavContact(_ model: UserModel) {
        let recipient = "xscanner@izysoft.net"
        let subject = "PostGram App Problem/Asking"
        
        var bodyContent = "User Information:\n"
        bodyContent += "ID: \(model.id.isEmpty ? "Not available" : model.id)\n"
        bodyContent += "Premium Status: \(model.isPremium ? "Premium" : "Free")\n"
        
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = bodyContent.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let mailtoURLString = "mailto:\(recipient)?subject=\(encodedSubject)&body=\(encodedBody)"
        
        if let mailtoURL = URL(string: mailtoURLString), UIApplication.shared.canOpenURL(mailtoURL) {
            UIApplication.shared.open(mailtoURL, options: [:], completionHandler: nil)
        }
    }
    
    func makeNavPrivacy() {
        if let url = URL(string: "https://www.izysoft.net/xscanner-privacy") {
            UIApplication.shared.open(url)
        }
    }
    
    func makeNavTerms() {
        if let url = URL(string: "https://www.izysoft.net/xscanner-terms") {
            UIApplication.shared.open(url)
        }
    }
    
    func makeRate() {
        RateUsManager.shared.requestReview()
    }
    
    func restorePurchases(_ completion: @escaping (Bool) -> ()) {
        Task {
            do {
                let customerInfo = try await revenueCatManager.restorePurchases()
                await MainActor.run {
                    let premiumIdentifiers = ["premium", "premium_access", "pro", "pro_access"]
                    let isSubscribed = premiumIdentifiers.contains { identifier in
                        customerInfo.entitlements[identifier]?.isActive == true
                    }
                    print("SettingsViewModel: Restore is \(isSubscribed)")
                    completion(isSubscribed)
                }
            } catch {
                print("SettingsViewModel: Restore purchases failed: \(error.localizedDescription)")
                await MainActor.run {
                    completion(false)
                }
            }
        }
    }
    
}

