//
//  GridStoriesView.swift
//  PostGram
//
//  Created by Mert Türedü on 8.04.2025.
//

import SwiftUI

struct GridStoriesView: View {
    let idType: Int
    
    init(
        _ idType: Int
    ) {
        self.idType = idType
    }
    
    var body: some View {
        VStack {
            BackHeaderView {    }
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
                        } else if idType == 11 {
                            type11View
                        } else if idType == 12 {
                            type12View
                        }
                    }
                    .foregroundStyle(ColorHandler.getColor(for: .bg))
                    .font(FontHandler.setFont(.bold, size: .xs12))
                }
            Spacer().frame(height: dh(0.04))
            SendMassageView {   }
            Spacer()
        }
        .frame(width: dw(1))
        .background(BackgroundView())
    }
}

#Preview {
    GridStoriesView(12)
}

private extension GridStoriesView {
    
    var type1View: some View {
        let size: CGSize = .init(width: 0.38, height: 0.18)
        return HStack {
            AddPhotoView(size)
            AddPhotoView(size)
        }
    }
    
    var type2View: some View {
        let size: CGSize = .init(width: 0.25, height: 0.13)
        return HStack {
            AddPhotoView(size)
            AddPhotoView(size)
            AddPhotoView(size)
        }
    }
    
    var type3View: some View {
        let size: CGSize = .init(width: 0.6, height: 0.25)
        return VStack {
            AddPhotoView(size)
            AddPhotoView(size)
        }
    }
    
    var type4View: some View {
        let size: CGSize = .init(width: 0.5, height: 0.19)
        return VStack {
            AddPhotoView(size)
            AddPhotoView(size)
            AddPhotoView(size)
        }
    }
    
    var type5View: some View {
        let size: CGSize = .init(width: 0.38, height: 0.15)
        return VStack {
            AddPhotoView(size)
            AddPhotoView(size)
            AddPhotoView(size)
            AddPhotoView(size)

        }
    }
    
    var type6View: some View {
        let size: CGSize = .init(width: 0.73, height: 0.26)
        return VStack {
            AddPhotoView(size)
            AddPhotoView(size)
        }
    }
    
    var type7View: some View {
        let size: CGSize = .init(width: 0.355, height: 0.25)
        return VStack {
            AddPhotoView(.init(width: 0.73, height: 0.26))
            HStack {
                AddPhotoView(size)
                AddPhotoView(size)
            }
        }
    }
    
    var type8View: some View {
        let size: CGSize = .init(width: 0.39, height: 0.21)
        return VStack {
            HStack {
                AddPhotoView(size)
                AddPhotoView(size)
            }
            HStack {
                AddPhotoView(size)
                AddPhotoView(size)
            }
        }
    }
    
    var type9View: some View {
        let size: CGSize = .init(width: 0.7, height: 0.26)
        return VStack {
            AddPhotoView(size)
                .offset(x: dw(-0.07))
            AddPhotoView(size)
                .offset(x: dw(0.07))
        }
    }
    
    var type10View: some View {
        let size: CGSize = .init(width: 0.42, height: 0.43)
        return HStack(spacing: 0) {
            AddPhotoView(size)
            AddPhotoView(size)

        }
    }
    
    var type11View: some View {
        let size: CGSize = .init(width: 0.42, height: 0.43)
        return HStack(spacing: 0) {
            AddPhotoView(size)
                .offset(y: dh(-0.05))
            AddPhotoView(size)
                .offset(y: dh(0.05))
        }
    }
    
    var type12View: some View {
        let size: CGSize = .init(width: 0.4, height: 0.2)
        return HStack(spacing: 0) {
            AddPhotoView(size)
                .offset(x: dw(0.2) ,y: dh(-0.1))
            AddPhotoView(size)
            AddPhotoView(size)
                .offset(x: dw(-0.2),y: dh(0.1))
        }
    }
}
