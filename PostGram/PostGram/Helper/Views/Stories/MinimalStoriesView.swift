//
//  MinimalStoriesView.swift
//  PostGram
//
//  Created by Mert Türedü on 8.04.2025.
//

import SwiftUI

struct MinimalStoriesView: View {
    
    @Environment(\.dismiss) var dismiss
    let idType: Int
    
    init(
        _ idType: Int
    ) {
        self.idType = idType
    }
    
    var body: some View {
        VStack {
            BackHeaderView { dismiss() }
            Spacer()
            BackgroundStoriesView()
                .overlay(alignment: .center) {
                    Group {
                        if idType == 1 {
                            type1View
                        } else if idType == 2 {
                            type2View
                        } else if idType == 3 {
                            type3View
                        } else if idType == 4 {
                            type4View
                        } else if idType == 5 {
                            type5View
                        }
                    }
                    .foregroundStyle(ColorHandler.getColor(for: .bg))
                    .font(FontHandler.setFont(.bold, size: .xs12))
                }
            Spacer().frame(height: dh(0.04))
            SendMassageView {

            }
            Spacer()
        }
        .frame(width: dw(1))
        .background(BackgroundView())
    }
}

#Preview {
    MinimalStoriesView(5)
}


private extension MinimalStoriesView {

    var type1View: some View {
        VStack {
            HStack {
                Text("RD")
                Spacer()
            }
            Spacer()
            AddPhotoView(.init(width: 0.7, height: 0.4))
            Spacer()
            HStack {
                Text("MM1")
                Spacer()
                Text("Young&Younger")
            }
        }
        .padding()
    }
    
    var type2View: some View {
        VStack {
            HStack {
                Text("RD")
                Spacer()
            }
            Spacer()
            AddPhotoView(.init(width: 0.7, height: 0.25))
            Spacer()
            HStack {
                Text("MM2")
                Spacer()
                Text("Young&Younger")
            }
        }
        .padding()
    }
    
    var type3View: some View {
        VStack {
            HStack {
                Text("RD")
                Spacer()
            }
            .offset(x: -dw(0.2))
            Spacer()
            AddPhotoView(.init(width: 1.2, height: 0.25))
            Spacer()
            HStack {
                Text("MM3")
                    .offset(x: -dw(0.2))
                Spacer()
                Text("Young&Younger")
                    .offset(x: dw(0.2))
            }
        }
        .frame(height: dw(0.8))
        .padding()
        .rotate(-90)
    }
    
    var type4View: some View {
        VStack {
            AddPhotoView(.init(width: 0.85, height: 0.55))
                .padding(-15)
            Spacer()
            HStack {
                Text("MM4")
                Spacer()
                Text("Young&Younger")
            }
        }

        .padding()
        .frame(width: dw(0.85), height: dh(0.67))
    }
    
    var type5View: some View {
        VStack {
            AddPhotoView(.init(width: 0.85, height: 0.67))
                .padding(-15)
        }
        .frame(width: dw(0.85), height: dh(0.67))
    }
    
}

