//
//  UserModel.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import Foundation

struct UserModel: Codable {
    
    let id: String
    var isPremium: Bool
    
    init(
        isPremium: Bool = false
    ) {
        self.id = UserStandard.userID
        self.isPremium = isPremium
    }
}
