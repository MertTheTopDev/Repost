//
//  ColorHandler.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import SwiftUI

struct ColorHandler {
    
    static func getColor(for color: ColorHelper.original) -> Color {
        Color(color.rawValue)
    }
        
}
