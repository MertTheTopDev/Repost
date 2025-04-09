//
//  PostView.swift
//  PostGram
//
//  Created by Mert Türedü on 7.04.2025.
//

import SwiftUI

struct PostView: View {
    
    @EnvironmentObject var state: PostGramState
    @StateObject var vm: PostViewModel
    
    init (
        
    ) {
        _vm = StateObject(wrappedValue: PostViewModel())
    }
    
    var body: some View {
        VStack {
            headerView
            repostTitle
            List(vm.savedPosts, id: \.id) { model in
                postRowView(model)
                    .swipeActions {
                        Button(role: .destructive) {
                            // Delete functionality
                            withAnimation {
                                vm.deletePost(model)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .listRowBackground(Color.clear)
            }
            .background(Color.clear)
            .listStyle(PlainListStyle())
        }
        .fullScreenCover(isPresented: .constant(!vm.isShownHowToUse), content: {
            howToRepostView
        })
        .fullScreenCover(item: $vm.selectedPost, content: { item in
            PostInsightView(item)
        })
        .frame(width: dw(1))
        .background(BackgroundView())
    }
}

#Preview {
    InsightRouter()
        .environmentObject(Mock.previewHelper.state)
}

private extension PostView {
    //MARK: - Header View -
    var headerView: some View {
        HStack {
            //TODO: Icon
            Image(systemName: "list.bullet")
                .resizable()
                .scaledToFit()
                .foregroundStyle(ColorHandler.getColor(for: .white))
                .frame(width: dw(0.08))
                .onTapGesture {
                    vm.isShownHowToUse.toggle()
                }
            Spacer()
        }
        .frame(width: dw(0.9))
    }
    //MARK: - Repost Title View -
    var repostTitle: some View {
        HStack {
            Text("Reposted Posts")
                .foregroundStyle(ColorHandler.getColor(for: .white))
                .font(FontHandler.setFont(.bold, size: .l18))
            Spacer()
        }
        .frame(width: dw(0.9))
        .padding(.vertical)
    }
    //MARK: - Post Row View -
    func postRowView(_ model: PostModel) -> some View {
        HStack(spacing: 0) {
            Image(uiImage: model.image)
                .resizable()
                .scaledToFit()
                .frame(height: dh(0.1))
            VStack(alignment: .leading) {
                /// Owner
                HStack(spacing: 5) {
                    Image(uiImage: model.ownerImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: dw(0.05))
                        .clipShape(Circle())
                    Text(model.owner)
                        .font(FontHandler.setFont(.medium, size: .m16))
                }
                Text(model.postDescription)
                    .font(FontHandler.setFont(.light, size: .s14))
                    
            }
            .foregroundStyle(ColorHandler.getColor(for: .white))
            .padding(.leading,15)
            .frame(height: dh(0.1), alignment: .top)
        }
        .frame(width: dw(0.9), height: dh(0.1))
    }
    
}


private extension PostView {
    //MARK: - How To Repost View -
    var howToRepostView: some View {
        VStack(alignment: .center) {
            Spacer().frame(height: dh(0.3))
            Text("How to Repost ?")
                .foregroundStyle(ColorHandler.getColor(for: .purple))
                .font(FontHandler.setFont(.bold, size: .h1))
            Spacer().frame(height: dh(0.05))
            VStack(alignment: .leading) {
                makeListView("Fint a post on your feed")
                makeListView(
                    "Click on the  or ... on button\non the top right of the post"
                )
                makeListView("Click on ''Copy Link''")
                makeListView("Come back to this app")
            }
            .padding(.horizontal)
            Spacer()
            Button {
                vm.isShownHowToUse.toggle()
            } label: {
                Text("Okey")
                    .foregroundStyle(ColorHandler.getColor(for: .white))
            }

        }
        .onAppear {
            UserStandard
                .set(true, forKey: UserStandardKey.isShownHowToUsePostKey)
        }
        .frame(width: dw(1))
        .background(BackgroundView())
    }
    //MARK: - Make List View -
    func makeListView(_ title: String, isNeedFlyIcon: Bool = false) -> some View {
        HStack {
            Circle().frame(width: dw(0.05))
                .foregroundStyle(ColorHandler.getColor(for: .purple))
            Text(title)
                .foregroundStyle(ColorHandler.getColor(for: .white))
                .font(FontHandler.setFont(.medium, size: .xxl24))
        }
        .frame(width: dw(0.9), alignment: .leading)
    }
    
}

