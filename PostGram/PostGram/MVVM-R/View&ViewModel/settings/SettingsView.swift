//
//  SettingsView.swift
//  PostGram
//
//  Created by Mert Türedü on 7.04.2025.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.layoutDirection) private var layoutDirection
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var state: PostGramState
    @StateObject var vm: SettingsViewModel
    
    init (
        _ isPresented: Binding<Bool>
    ) {
        _vm = StateObject(wrappedValue: SettingsViewModel(isPresented))
    }
    
    var body: some View {
        VStack {
            headerView
            if !state.user.isPremium {
                bannerView
            }
            Spacer().frame(height: dh(0.05))
            VStack(spacing: 16) {
     
                makeButtonView("Contact Us", mail: "xscanner@izysoft.net") {
                    vm.makeNavContact(state.user)
                }
                makeButtonView("Privacy Policy") { vm.makeNavPrivacy() }
                makeButtonView("Terms of Use") { vm.makeNavTerms() }
                makeButtonView("Rate Us") { vm.makeRate() }
                
                if !state.user.isPremium {
                    makeButtonView("Restore Purchases") {
                        vm.restorePurchases { state.user.isPremium = $0 }
                    }
                    .padding(.top,40)
                }
            }
            Spacer()
        }
        .frame(width: dw(1))
        .sheet(isPresented: $vm.isAppearPremium, content: {
            PaywallView()
        })
        .background(BackgroundView())
    }
}

#Preview {
    SettingsView(.constant(true))
        .environmentObject(Mock.previewHelper.state)
}

private extension SettingsView {
    //MARK: - Header View -
    var headerView: some View {
        ZStack {
            Text("Settings")
                .foregroundStyle(ColorHandler.getColor(for: .white))
                .font(FontHandler.setFont(.bold, size: .xxl24))
            HStack {
                Spacer()
                ImageHandler.shared.getIcons(.circleCancel)
                    .scaledToFit()
                    .frame(height: dh(0.03))
                    .onTapGesture {
                        vm.closeSettings()
                    }
            }
        }
        .frame(width: dw(0.9))
        .padding(.top)
    }
    //MARK: - Make Button View -
    func makeButtonView(_ title: LocalizedStringKey, mail: String = "",  isToggle: Bool = false, hide: Bool = false, action: @escaping () -> ()) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(ColorHandler.getColor(for: .black))
            .frame(height: dh(0.07))
            .overlay(alignment: .center) {
                HStack {
                    Text(title)
                        .foregroundStyle(ColorHandler.getColor(for: .white))
                        .font(FontHandler.setFont(.bold, size: .l18))
                    
                    Spacer()
                    if hide {
                        
                    } else if mail.count > 0 {
                        Text(mail)
                            .foregroundStyle(ColorHandler.getColor(for: .white))
                            .font(FontHandler.setFont(.light, size: .m16))
                    } else {
                        ImageHandler.shared.getIcons(.boldArrow)
                            .scaledToFit()
                            .frame(height: dh(0.03))
                    }
                }
                .padding(.horizontal,20)
            }
            .onTapGesture {
                withAnimation(.linear) {
                    action()
                }
            }
            .frame(width: dw(0.9))
    }
}


private extension SettingsView {
    //MARK: - Banner View -
    var bannerView: some View {
        ImageHandler.shared.getImage(.goProBanner)
            .scaledToFit()
            .frame(width: dw(0.85))
            .scaleEffect(
                x: layoutDirection == .rightToLeft ? -1 : 1,
                y: 1,
                anchor: .center
            )
            .overlay(alignment: .leading) { HStack{ contentView; Spacer()}}
            .cornerRadius(12)
            .onTapGesture {
                withAnimation(.linear) { vm.isAppearPremium.toggle() }
            }
    }
    //MARK: - Banner Content View -
    var contentView: some View {
        
        let isArabic = layoutDirection == .rightToLeft
        
        return VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .top,spacing: 0) {
                /// Title
                Text("Go PRO!")
                    .foregroundStyle( ColorHandler.getColor(for: .white) )
                    .font(
                        FontHandler
                            .setFont(.bold, size: isArabic ? .xl20 : .xxxl28)
                    )
                    
                ImageHandler.shared.getIcons(.stars)
                    .scaledToFit()
                    .frame(height: dw(0.08))
            }
            Text("Discover the Full Power of\nXScanner Pro experience")
                .foregroundStyle(ColorHandler.getColor(for: .white))
                .font(FontHandler.setFont(.bold, size: .l18))
                .multilineTextAlignment(.leading)
        }
        .frame(width: dw(0.6),alignment: .leading)
        .offset(x: dw(isIPad() ? 0.19 : 0.04))
    }
    
    func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
}
