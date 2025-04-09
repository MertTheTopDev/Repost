//
//  PaywallView.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import SwiftUI

struct PaywallView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var state: PostGramState
    @StateObject var vm: PaywallViewModel
    
    init(
        
    ) {
        _vm = StateObject(wrappedValue: PaywallViewModel())
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            priceAndTitleView
            Spacer().frame(height: dh(0.25))
            buttonView
        }
        .overlay(alignment: .topTrailing, content: {
            ImageGridView()
                .rotate(-35)
                .offset(x: dw(0.35), y: dh(-0.2))
        })
        .background(BackgroundView())
    }
}

#Preview {
    PaywallView()
        .environmentObject(Mock.previewHelper.state)
}

private extension PaywallView {
    
    var priceAndTitleView: some View {
        HStack {
            VStack {
                Text("Only 0.99/week")
                    .foregroundStyle(ColorHandler.getColor(for: .green))
                    .font(FontHandler.setFont(.bold, size: .xl20))
                Spacer()
                    .frame(height: dh(0.04))
                Text("Get Unlimited\nAccess")
                    .foregroundStyle(ColorHandler.getColor(for: .purple))
                    .font(FontHandler.setFont(.bold, size: .h1))
            }
            .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(width: dw(0.9))
        .padding(.horizontal,dw(0.05))}
    
    var buttonView: some View {
        
        Button {
            if let package = vm.selectedPackage {
                vm.purchase(package: package) { isPurchased in
                    if isPurchased {
                        dismiss()
                        state.user.isPremium = isPurchased
                    }
                }
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(ColorHandler.getColor(for: .purple))
                Text("Continue")
                    .foregroundStyle(ColorHandler.getColor(for: .white))
                    .font(FontHandler.setFont(.bold, size: .xl20))
                HStack {
                    Image(systemName: "arrowshape.right.fill")
                        .foregroundStyle(ColorHandler.getColor(for: .white))
                }
            }
        }
        .frame(width: dw(0.8), height: dh(0.07))
        
    }
    
}
