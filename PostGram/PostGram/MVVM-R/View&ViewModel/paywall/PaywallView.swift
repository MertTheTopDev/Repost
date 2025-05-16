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
            buttonView
        }
        .overlay(alignment: .topTrailing, content: {
            ZStack(alignment: .bottom) {
                ImageGridView()
                LinearGradient(stops: [
                    .init(color: ColorHandler.getColor(for: .bg).opacity(0.05), location: 0),
                    .init(color: ColorHandler.getColor(for: .bg).opacity(0.8), location: 1)
                                      ],
                               startPoint: .top,
                               endPoint: .bottom)
                .frame(height: dh(0.1))
            }
                .offset(y: dh(-0.17))
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
        VStack {
            Text("Get Unlimited\nAccess")
                .foregroundStyle(ColorHandler.getColor(for: .purple))
                .font(FontHandler.setFont(.bold, size: .h1))
            Spacer()
            Text("Remove the stamp. No ads.")
                .foregroundStyle(ColorHandler.getColor(for: .green))
                .font(FontHandler.setFont(.bold, size: .m16))
            Spacer()

            if let package = vm.selectedPackage {
                Text("Only 0.99 \(vm.makePackage(package)) /Week")
                    .foregroundStyle(ColorHandler.getColor(for: .white))
                    .font(FontHandler.setFont(.bold, size: .s14))
            }
        }
        .multilineTextAlignment(.center)
        .frame(width: dw(1),height: dh(0.17))
        .padding()
    }
    
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
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(ColorHandler.getColor(for: .blue))
                Text("Continue")
                    .foregroundStyle(ColorHandler.getColor(for: .white))
                    .font(FontHandler.setFont(.bold, size: .xxl24))
                HStack {
                    Spacer()
                    Image(systemName: "arrowshape.right.fill")
                        .foregroundStyle(ColorHandler.getColor(for: .white))
                }
                .padding(.horizontal)
            }
        }
        .frame(width: dw(0.9), height: dh(0.07))
        
    }
    
}
