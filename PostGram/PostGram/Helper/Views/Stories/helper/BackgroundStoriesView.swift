//
//  BackgroundStoriesView.swift
//  PostGram
//
//  Created by Mert Türedü on 8.04.2025.
//

import SwiftUI

struct BackgroundStoriesView: View {
    
    
    var body: some View {
        Rectangle()
            .foregroundStyle(ColorHandler.getColor(for: .white))
            .frame(width: dw(0.85), height: dh(0.67))
    }
}

#Preview {
    BackgroundStoriesView()
}
