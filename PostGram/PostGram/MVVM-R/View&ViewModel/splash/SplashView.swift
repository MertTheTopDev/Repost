//
//  SplashView.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var state: PostGramState
    @StateObject var vm: SplashViewModel
    
    init() {
        _vm = StateObject(wrappedValue: SplashViewModel())
    }
    
    var body: some View {
        ZStack {
            if vm.isAppLoaded {
                InsightRouter()
            } else {
                BackgroundView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            vm.isAppLoaded = true
                        }
                    }
            }
        }
        .environmentObject(state)
    }
}
//MARK: - Preview -
#Preview {
    SplashView()
        .environmentObject(Mock.previewHelper.state)
}

private extension SplashView {

    
}
