//
//  AddPhotoView.swift
//  PostGram
//
//  Created by Mert Türedü on 8.04.2025.
//

import SwiftUI

struct AddPhotoView: View {
    
    @State private var selectedImage: UIImage?
    let size: CGSize
    
    init(
        _ size: CGSize
    ) {
        self.size = size
    }
    
    var body: some View {
        
        Group {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    
            } else {
                addPhotoTemplateView
            }
        }
        .frame(width: dw(size.width), height: dh(size.height))
        .onTapGesture {
            PhotoPickerManager.shared.selectPhoto { selectedImage = $0 }
        }
    }
}

#Preview {
    AddPhotoView(.init(width: 0.5, height: 0.2))
}

extension AddPhotoView {
    var addPhotoTemplateView: some View {
        
        ColorHandler.getColor(for: .bg)
            .opacity(0.2)
            .overlay(alignment: .center) {
                VStack {
                    Image(systemName: "plus.rectangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: dw(0.09))
                    Text("Add Photo")
                        .font(FontHandler.setFont(.bold, size: .m16))
                        .multilineTextAlignment(.center)
                }
                .foregroundStyle(ColorHandler.getColor(for: .bg))
            }
        
    }
}
