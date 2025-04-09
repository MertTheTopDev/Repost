//
//  SendMassageView.swift
//  PostGram
//
//  Created by Mert Türedü on 8.04.2025.
//

import SwiftUI

struct SendMassageView: View {
    
    @EnvironmentObject var state: PostGramState
    let action: () -> Void
    
    init(
        _ action: @escaping () -> Void
    ) {
        self.action = action
    }
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: action) {
                Image(systemName: "paperplane")
                    .resizable()
                    .foregroundStyle(ColorHandler.getColor(for: .white))
                    .scaledToFit()
                    .frame(width: dw(0.09))
            }
                
        }
        .frame(width: dw(0.9))
    }
}

#Preview {
    ZStack {
        BackgroundView()
        SendMassageView { }
    }
    .environmentObject(Mock.previewHelper.state)
}
