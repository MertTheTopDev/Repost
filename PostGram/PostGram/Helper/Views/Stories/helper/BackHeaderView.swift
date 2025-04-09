//
//  BackHeaderView.swift
//  PostGram
//
//  Created by Mert Türedü on 8.04.2025.
//

import SwiftUI

struct BackHeaderView: View {
    
    @EnvironmentObject var state: PostGramState
    
    let action: () -> Void
    
    init(
        _ action: @escaping () -> Void
    ) {
        self.action = action
    }
    
    var body: some View {
        HStack {
            Button(action: action) {
                ImageHandler.shared.getIcons(.boldArrow)
                    .scaledToFit()
                    .frame(width: dw(0.02))
                    .rotate(180)
                Text("Back")
                    .foregroundStyle(ColorHandler.getColor(for: .white))
                    .font(FontHandler.setFont(.bold, size: .xl20))
            }
            Spacer()
        }
        .frame(width: dw(0.9))
    }
}

#Preview {
    ZStack {
        BackgroundView()
        BackHeaderView { }
    }
    .environmentObject(Mock.previewHelper.state)
}
