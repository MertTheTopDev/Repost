//
//  FontHandler.swift
//  Balloon
//
//  Created by Mert Türedü on 1.04.2025.
//

import SwiftUI

struct FontHandler {
    static func setFont(_ weight: Font.Weight, size: FontHelper.size) -> Font {
        
        Font.system(size: size.rawValue).weight(weight)
    }
}
