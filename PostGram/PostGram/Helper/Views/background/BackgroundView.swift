//
//  BackgroundView.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import SwiftUI

struct BackgroundView: View {
    
    var body: some View {
        ColorHandler.getColor(for: .bg)
            .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
