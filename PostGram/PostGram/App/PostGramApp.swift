//
//  PostGramApp.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import SwiftUI
import UIKit
import FacebookCore

@main
struct PostGramApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var state: PostGramState
    
    init() {
        _state = StateObject(wrappedValue: PostGramState())
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(state)
        }
    }
}
