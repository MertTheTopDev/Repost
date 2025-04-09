//
//  UserDefaults+Ext.swift
//  Balloon
//
//  Created by Mert Türedü on 5.04.2025.
//

import Foundation

let UserStandard = UserDefaults.standard
let UserStandardKey = UserDefaults.Key.shared

extension UserDefaults {
    
    struct Key {
        static let shared = Key()
        
        let userIDKey = "userID"
        let beforeLoginKey = "beforeLogin"
        
        let isShownHowToUsePostKey = "isShownHowToUsePost"
        let isCopyCaptionAutoKey = "isCopyCaptionAuto"
    }
    
    @objc dynamic var userID: String {
        UserStandard.string(forKey: Key.shared.userIDKey) ?? ""
    }
    
    @objc dynamic var isBeforeLogin: Bool {
        UserStandard.bool(forKey: Key.shared.beforeLoginKey)
    }
    /// Views
    @objc dynamic var isShownHowToUsePost: Bool {
        UserStandard.bool(forKey: Key.shared.isShownHowToUsePostKey)
    }
    
    @objc dynamic var isCopyCaptionAuto: Bool {
        UserStandard.bool(forKey: Key.shared.isCopyCaptionAutoKey)
    }
    
}
