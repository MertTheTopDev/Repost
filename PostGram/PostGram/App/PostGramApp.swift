//
//  PostGramApp.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import SwiftUI

@main
struct PostGramApp: App {

    @StateObject var state: PostGramState
    
    init() {
        _state = StateObject(wrappedValue: PostGramState())
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(PostGramState())
        }
    }
}
