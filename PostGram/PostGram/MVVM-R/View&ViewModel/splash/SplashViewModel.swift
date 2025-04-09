//
//  SplashViewModel.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import Foundation

class SplashViewModel: ObservableObject {
    
    @Published var isAppLoaded: Bool
    
    init(isAppLoaded: Bool = false) {
        self.isAppLoaded = isAppLoaded
    }
    
}
