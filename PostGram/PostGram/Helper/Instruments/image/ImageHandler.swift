//
//  ImageHandler.swift
//  PostGram
//
//  Created by Mert Türedü on 7.04.2025.
//

import SwiftUI

struct ImageHandler {
    
    static let shared = ImageHandler()
    
    func getIcons(_ icon: ImageHelper.icon) -> some View {
        Image(icon.rawValue)
            .resizable()
    }
    
    func getImage(_ image: ImageHelper.image) -> some View {
        Image(image.rawValue)
            .resizable()
    }
    
}
