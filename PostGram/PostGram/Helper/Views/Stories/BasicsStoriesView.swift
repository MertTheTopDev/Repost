//
//  BasicsStoriesView.swift
//  PostGram
//
//  Created by Mert Türedü on 8.04.2025.
//

import SwiftUI

struct BasicsStoriesView: View {
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
                        } else if idType == 6 {
                            type6View
                        } else if idType == 7 {
                            type7View
                        } else if idType == 8 {
                            type8View
                        } else if idType == 9 {
                            type9View
                        } else if idType == 10 {
                            type10View
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
    BasicsStoriesView(10)
}

private extension BasicsStoriesView {
    
    var type1View: some View {
        AddPhotoView(.init(width: 0.75, height: 0.5))
            .offset(y: dh(-0.05))
    }
    
    
    var type2View: some View {
        AddPhotoView(.init(width: 0.84, height: 0.23))
    }
    
    var type3View: some View {
        VStack {
            AddPhotoView(.init(width: 0.84, height: 0.23))
            AddPhotoView(.init(width: 0.84, height: 0.23))
        }
    }
    
     var type4View: some View {
        AddPhotoView(.init(width: 0.8, height: 0.62))
    }
    
    var type5View: some View {
        VStack(spacing: 0) {
            AddPhotoView(.init(width: 0.73, height: 0.2))
            AddPhotoView(.init(width: 0.73, height: 0.2))
            AddPhotoView(.init(width: 0.73, height: 0.2))
        }
    }
    
    var type6View: some View {
        let height = 0.3
        
        return VStack {
            AddPhotoView(.init(width: 0.73, height: height))
            AddPhotoView(.init(width: 0.73, height: height))
        }
    }
    
    var type7View: some View {
        AddPhotoView(.init(width: 0.73, height: 0.67))
            .offset(x: dw(0.055))
    }
    
    var type8View: some View {
        AddPhotoView(.init(width: 0.47, height: 0.67))
            .offset(x: dw(0.19))
    }
    
    var type9View: some View {
        AddPhotoView(.init(width: 0.7, height: 0.47))
            .offset(x: dw(-0.07))
    }
    
    var type10View: some View {
        AddPhotoView(.init(width: 0.7, height: 0.47))
            .offset(x: dw(0.07))
    }
}
