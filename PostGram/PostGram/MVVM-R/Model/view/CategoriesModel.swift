//
//  CategoriesModel.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import SwiftUI

struct CategoriesModel: Identifiable {
    let id: Int
    let emoji: String
    let name: LocalizedStringKey
    let hashtags: ([String], [String], [String])
    
    var totalHashtagCount: Int {
        return hashtags.0.count + hashtags.1.count + hashtags.2.count
    }
}
