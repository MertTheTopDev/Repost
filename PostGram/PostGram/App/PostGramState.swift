//
//  PostGramState.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import Foundation

class PostGramState: ObservableObject {
    
    @Published var user: UserModel
    let revenueCatManager: RevenueCatManager
    
    init(user: UserModel = .init(),
    revenueCatManager: RevenueCatManager = .shared) {
        self.user = user
        self.revenueCatManager = revenueCatManager
    }
    
}

extension PostGramState {
    func getPremium() {
        Task { 
            
            async let offeringsTask: () = revenueCatManager.fetchOfferings()

            _ = await offeringsTask
            
            let isSubs = revenueCatManager.isSubscribed()
            print("XScannerState: Premium Status -> \(isSubs)")
            user.isPremium = isSubs
        }
    }
    
}
