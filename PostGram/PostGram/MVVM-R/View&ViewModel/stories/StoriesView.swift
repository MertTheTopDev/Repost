//
//  StoriesView.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import SwiftUI

struct StoriesView: View {
    
    @EnvironmentObject var state: PostGramState
    @StateObject var vm: StoriesViewModel
    
    init (
        
    ) {
        _vm = StateObject(wrappedValue: StoriesViewModel())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Stories")
                .foregroundStyle(ColorHandler.getColor(for: .white))
                .font(FontHandler.setFont(.black, size: .xxl24))
                .padding(.leading)
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    makeRowStories("Minimal",key:"M", image: ["image1", "image1","image1", "image1","image1", "image1"])
                    makeRowStories("Basics",key:"B", image: ["image1", "image1","image1", "image1","image1", "image1"])
                    makeRowStories("Grids",key:"G", image: ["image1", "image1","image1", "image1","image1", "image1"])
                    makeRowStories("Screens",key:"S", image: ["image1", "image1","image1", "image1","image1", "image1"])
                    makeRowStories("Screens",key:"S", image: ["image1", "image1","image1", "image1","image1", "image1"])
                        .opacity(0)
                        .disabled(true)
                }

            }
            Spacer()
        }
        .frame(width: dw(1))
        .background(BackgroundView())
        .fullScreenCover(isPresented: $vm.isSheetAppear) {
            let type = ((vm.type ?? 0) + 1)
            switch vm.selectedStories! {
                case "K":
                MinimalStoriesView(type)
                case "B":
                BasicsStoriesView(type)
                case "G":
                GridStoriesView(type)
                case "S":
                ScreenStoriesView(type)
            default:
                MinimalStoriesView(type)
            }
        }
    }
}

#Preview {
    InsightRouter(.init(currentView: .stories))
        .environmentObject(Mock.previewHelper.state)
}

extension StoriesView {
    
    func makeRowStories(_ title: LocalizedStringKey, key: String, image: [String]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .foregroundStyle(ColorHandler.getColor(for: .white))
                .font(FontHandler.setFont(.bold, size: .m16))
            
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        ForEach(image.indices) { index in
                            let image = image[index]
                            Button {
                                vm.type = index
                                vm.selectedStories = key
                                print("Thats \(vm.selectedStories)")
                                vm.isSheetAppear = true
                            } label: {
                                Image(image)
                                    .resizable()
                                    .frame(width: dw(0.18), height: dh(0.14))
                                    .cornerRadius(10)
                            }

                    }
                }
            }
        }
        .padding(.leading)
    }
    
}
