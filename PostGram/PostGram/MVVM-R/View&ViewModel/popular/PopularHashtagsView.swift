//
//  PopularHashtagsView.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import SwiftUI

struct PopularHashtagsView: View {
    
    @EnvironmentObject var state: PostGramState
    @StateObject var vm: PopularHashtagsViewModel
    
    init (
        
    ) {
        _vm = StateObject(wrappedValue: PopularHashtagsViewModel())
    }
    
    var body: some View {
        VStack {
            Text("Popular Hashtags")
                .foregroundStyle(ColorHandler.getColor(for: .white))
                .font(FontHandler.setFont(.bold, size: .h2))
            bannerView
            Spacer()
            categoriesView
            
        }
        .frame(width: dw(1))
        .fullScreenCover(item: $vm.selectedModel, content: { model in
            makePopularSheetView(model)
        })
        .background(BackgroundView())
    }
}

#Preview {
    PopularHashtagsView()
        .environmentObject(Mock.previewHelper.state)
}

private extension PopularHashtagsView {
    //MARK: - Banner View -
    var bannerView: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 125.0 / 255.0, green: 57.0 / 255.0, blue: 247.0 / 255.0), location: 0.0),
                    Gradient.Stop(color: Color(red: 0.0, green: 214.0 / 255.0, blue: 1.0), location: 1.0)],
                startPoint: UnitPoint(x: -0.1, y: 0.9),
                endPoint: UnitPoint(x: 1.0, y: 0.2)))
            .frame(width: dw(0.9),height: dh(0.15))
            .overlay(alignment: .center) {
                VStack {
                    Text("Search for the most popular tags\non social media")
                        .foregroundStyle(ColorHandler.getColor(for: .white))
                        .font(FontHandler.setFont(.bold, size: .xl20))
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(ColorHandler.getColor(for: .white))
                            .frame(width: dw(0.4),height: dh(0.03))
                            .overlay {
                                Text("Trending Tags")
                                    .foregroundStyle(ColorHandler.getColor(for: .bg))
                                    .font(FontHandler.setFont(.semibold, size: .s14))
                            }
                        Spacer()
                    }
                }
                .padding(.horizontal,15)
            }
    }
    
   
    //MARK: - Categories View -
    var categoriesView: some View {
        VStack {
            HStack {
                Text("Top Categories")
                    .foregroundStyle(ColorHandler.getColor(for: .white))
                    .font(FontHandler.setFont(.bold, size: .xl20))
                Spacer()
            }
            ScrollView(.vertical) {
                LazyVGrid(columns: [.init(.flexible()),
                                    .init(.flexible())],
                          spacing: 25) {
                    ForEach(vm.makeCategories(), id: \.id) { model in
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(ColorHandler.getColor(for: .black))
                            .overlay(alignment: .center) {
                                HStack {
                                    Text(model.emoji)
                                    VStack(alignment: .leading) {
                                        Text(model.name)
                                            .font(FontHandler.setFont(.bold, size: .S15))
                                        Text(model.totalHashtagCount.description + " Hashtags")
                                            .font(FontHandler.setFont(.light, size: .xs12))
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: dw(0.02))
                                }
                                .foregroundStyle(ColorHandler.getColor(for: .white))
                                .padding(.horizontal)
                            }
                            .frame(width: dw(0.4),height: dh(0.07))
                            .onTapGesture {
                                vm.selectedModel = model
                            }
                    }
                }
                
            }
        }
        .frame(width: dw(0.9))
        .padding(.top)
    }
    
    
}

private extension PopularHashtagsView {
    //MARK: - Make Popular Sheet View -
    func makePopularSheetView(_ model: CategoriesModel) -> some View {
        VStack {
            ZStack {
                Text("Popular")
                    .font(FontHandler.setFont(.bold, size: .h1))
                HStack {
                    Group {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: dw(0.02))
                        Text("Back")
                            .font(FontHandler.setFont(.semibold, size: .m16))
                    }
                    .onTapGesture {
                        vm.selectedModel = nil
                    }
                    Spacer()
                }
            }
            .foregroundStyle(ColorHandler.getColor(for: .white))
            .frame(width: dw(0.9))
            Spacer().frame(height: dh(0.03))
            Text("Tap the box to copy the content")
                .foregroundStyle(ColorHandler.getColor(for: .white))
                .font(FontHandler.setFont(.regular, size: .m16))
            
            makeHashTagView("Popular with Most Posts", hash: model.hashtags.0)
            Spacer().frame(height: dh(0.03))
            makeHashTagView("Popular Following", hash: model.hashtags.1)
            Spacer().frame(height: dh(0.03))
            makeHashTagView("Popular Likes", hash: model.hashtags.2)
            Spacer()
        }
        .frame(width: dw(1))
        .background(BackgroundView())
    }
    
    func makeHashTagView(_ title: LocalizedStringKey, hash: [String]) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(ColorHandler.getColor(for: .black))
            .overlay(alignment: .top) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(FontHandler.setFont(.black, size: .xxl24))
                    
                    CopyableHashtagText(hash: hash)
                }
                .foregroundStyle(ColorHandler.getColor(for: .white))
                .frame(width: dw(0.8),alignment: .leading)
                .padding(10)
            }
            .frame(width: dw(0.9), height: dh(0.2), alignment: .top)
    }
}


struct CopyableHashtagText: View {
    let hash: [String]
    @State private var justCopied = false
    
    var body: some View {
        Text(hash.joined(separator: " "))
            .foregroundStyle(ColorHandler.getColor(for: .white))
            .font(FontHandler.setFont(.light, size: .S15))
            .multilineTextAlignment(.leading)
            .onTapGesture {
                UIPasteboard.general.string = hash.joined(separator: " ")
                withAnimation {
                    justCopied = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        justCopied = false
                    }
                }
            }
            .overlay(alignment: .center) {
                if justCopied {
                    Text("Copied")
                        .foregroundStyle(ColorHandler.getColor(for: .bg))
                        .font(FontHandler.setFont(.regular, size: .m16))
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(ColorHandler.getColor(for: .white))
                                .padding(.horizontal,-5)
                        )
                        .padding(4)
                }
            }
    }
}
