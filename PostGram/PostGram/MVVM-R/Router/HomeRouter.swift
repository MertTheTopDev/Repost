//
//  HomeRouter.swift
//  Balloon
//
//  Created by Mert Türedü on 3.04.2025.
//

import SwiftUI

enum InsightViews: CaseIterable {
    case post
    case stories
    case hashtags
}

class InsightRouterPresenter: ObservableObject {
    
    @Published var currentView: InsightViews
    @Published var isSettingsPresented: Bool
    
    init(currentView: InsightViews = .post,
         isSettingsPresented: Bool = false) {
        self.currentView = currentView
        self.isSettingsPresented = isSettingsPresented
    }
    
    func navigate(to view: InsightViews) {
        withAnimation(.easeIn(duration: 0.5)) {
            self.currentView = view
        }
    }
    
}

struct InsightRouter: View {
    @EnvironmentObject var state: PostGramState
    @StateObject private var presenter: InsightRouterPresenter
    
    init(_ presenter: InsightRouterPresenter = .init()) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    var body: some View {
        
        ZStack {
            switch presenter.currentView {
            case .post:
                PostView()
            case .stories:
                StoriesView()
            case .hashtags:
                PopularHashtagsView()
            }
        }
        .sheet(isPresented: $presenter.isSettingsPresented, content: {
            SettingsView($presenter.isSettingsPresented)
        })
        .overlay(alignment: .bottom) {
            navBarView
        }
        .environmentObject(state)
    }
    
}

#Preview {
    InsightRouter()
        .environmentObject(Mock.previewHelper.state)
}

private extension InsightRouter {
    
    var navBarView: some View {
        let icon = ImageHandler.shared
        
        
        return RoundedRectangle(cornerRadius: 30)
            .foregroundStyle(ColorHandler.getColor(for: .purple))
            .overlay(alignment: .center, content: {
                HStack {
                    //TODO: Icons
                    Spacer()
                    Group {
                        if presenter.currentView == .post {
                            icon.getIcons(.repostSelected)
                        } else {
                            icon.getIcons(.repostUnselected)
                        }
                    }
                        .onTapGesture { presenter.navigate(to: .post) }
                    Spacer()
                    Group {
                        if presenter.currentView == .stories {
                            icon.getIcons(.storySelected)
                        } else {
                            icon.getIcons(.storyUnselected)
                        }
                    }
                    .onTapGesture { presenter.navigate(to: .stories) }

                    Spacer()
                    Group {
                        if presenter.currentView == .hashtags {
                            icon.getIcons(.hashtagSelected)
                        } else {
                            icon.getIcons(.hashtagUnselected)
                        }
                    }
                    .onTapGesture { presenter.navigate(to: .hashtags) }
                    Spacer()
                    Group {
                        if presenter.isSettingsPresented == true {
                            icon.getIcons(.settingsSelected)
                        } else {
                            icon.getIcons(.settingsUnselected)
                        }
                    }
                        .onTapGesture { presenter.isSettingsPresented.toggle() }
                    Spacer()
                }
                .padding()
            })
            .frame(width: dw(0.6), height: dh(0.06))
    }
    
    
}
