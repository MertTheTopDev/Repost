//
//  PostInsightView.swift
//  PostGram
//
//  Created by Mert Türedü on 7.04.2025.
//

import SwiftUI
//MARK: - View -
struct PostInsightView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var state: PostGramState
    @StateObject var vm: PostInsightViewModel
    
    init (
        _ model: PostModel
    ) {
        _vm = StateObject(wrappedValue: PostInsightViewModel(model))
    }
    
    var body: some View {
        VStack {
            headerView
            Text(vm.model.owner)
                .foregroundStyle(ColorHandler.getColor(for: .white))
                .font(FontHandler.setFont(.bold, size: .xl20))
            contentView
            Spacer().frame(height: dh(0.04))
            selectCornerView
            selectColorView
            moreSettingsView
            buttonView
        }
        .frame(width: dw(1))
        .background(BackgroundView())
        .overlay(alignment: .center, content: {
            if vm.isSheetAppear || vm.isSheetReposting {
                Rectangle()
                    .foregroundStyle(ColorHandler.getColor(for: .bg))
                    .opacity(0.7)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            vm.isSheetAppear = false
                            vm.isSheetReposting = false
                        }
                    }
            }
        })
        .sheet(isPresented: $vm.isSheetAppear) {
            sheetView
                .modifier(SheetModifier(0.5))
        }
        .sheet(isPresented: $vm.isSheetReposting) {
            repostingSheet
                .modifier(SheetModifier(0.5))
        }
    }
}
//MARK: Preview
#Preview {
    PostInsightView(Mock.previewHelper.posts.first!)
        .environmentObject(Mock.previewHelper.state)
}

private extension PostInsightView {
    //MARK: - Header View -
    var headerView: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Text("Back")
                    .foregroundStyle(ColorHandler.getColor(for: .white))
                    .font(FontHandler.setFont(.medium, size: .xl20))
            }

            Spacer()
        }
        .frame(width: dw(0.9))
    }
    //MARK: - Content View -
    var contentView: some View {
        let textColor: ColorHelper.original = vm.selectedColor == .black ? .white : .black
        
        return ZStack {
            if let video = vm.model.video {
                
            } else {
                Image(uiImage: vm.model.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: dw(0.9))
            }
        }
        .overlay(alignment: vm.selectedCorner) {
            if vm.selectedCorner != .center {
                HStack {
                    Image(uiImage: vm.model.ownerImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: dw(0.06))
                        .clipShape(Circle())
                        .padding(.vertical,5)
                    Text(vm.model.owner)
                        .foregroundStyle(ColorHandler.getColor(for: textColor))
                        .font(FontHandler.setFont(.bold, size: .S15))
                }
                .padding(.horizontal)
                    .background {
                        Rectangle()
                            .foregroundStyle(Color(uiColor: vm.selectedColor))
                    }
                    .offset(x: 10)
            }
        }
    }
    
    //MARK: - Select Corner View -
    var selectCornerView: some View {
        func makeCornerShowcase(_ alignment: Alignment, action: @escaping () -> ()) -> some View {
            Button {
                withAnimation(.easeInOut) {
                    action()
                }
            } label: {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(ColorHandler.getColor(for: .white))
                    .overlay(alignment: alignment) {
                        if alignment != .center {
                            Rectangle()
                                .foregroundStyle(ColorHandler.getColor(for: .white))
                                .frame(width: dw(0.05), height: dh(0.01))
                        }
                    }
            }
            .frame(width: dw(0.1))

        }
        
        return VStack {
            Text("Select Corner")
                .foregroundStyle(ColorHandler.getColor(for: .white))
                .font(FontHandler.setFont(.bold, size: .l18))
            dividerView
            HStack(spacing: 20) {
                
                makeCornerShowcase(.topLeading) {
                    vm.selectedCorner = .topLeading
                }
                
                makeCornerShowcase(.topTrailing) {
                    vm.selectedCorner = .topTrailing
                }
                
                makeCornerShowcase(.bottomLeading) {
                    vm.selectedCorner = .bottomLeading
                }
                
                makeCornerShowcase(.bottomTrailing) {
                    vm.selectedCorner = .bottomTrailing
                }
                
                makeCornerShowcase(.center) {
                    vm.selectedCorner = .center
                }
                
            }
            .frame(height: dh(0.035))
            dividerView
        }
        
       
    }
    //MARK: - Select Color View -
    var selectColorView: some View {
        VStack {
            Text("Select Color")
                .foregroundStyle(ColorHandler.getColor(for: .white))
                .font(FontHandler.setFont(.bold, size: .l18))
            dividerView
            
            HStack(spacing: 20) {
                Button {
                    vm.changeColor(.white)
                } label: {
                    Circle()
                        .foregroundStyle(ColorHandler.getColor(for: .white))
                }
                    
                Button {
                    vm.changeColor(.black)
                } label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(ColorHandler.getColor(for: .white))
                        Circle()
                            .foregroundStyle(ColorHandler.getColor(for: .black))
                            .padding(1)
                    }
                }
            }
            .frame(height: dh(0.05))
            .padding(.vertical,5)
        }
    }
    //MARK: - More Settings View -
    var moreSettingsView: some View {
        VStack {
            dividerView
            Button {
                vm.isSheetAppear.toggle()
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text("More Settings")
                            .font(FontHandler.setFont(.bold, size: .l18))
                        Text("Caption And Location")
                            .font(FontHandler.setFont(.light, size: .xs12))
                    }
                    .foregroundStyle(ColorHandler.getColor(for: .white))
                    Spacer()
                    ImageHandler.shared.getIcons(.boldArrow)
                        .scaledToFit()
                        .frame(width: dw(0.04))
                }
                .frame(width: dw(0.9))
                .padding(.vertical,5)
            }

            dividerView
        }
    }
    //MARK: - Button View -
    var buttonView: some View {
        Button {
            withAnimation {
                vm.isSheetReposting = true
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(ColorHandler.getColor(for: .blue))
                Text("Repost")
                    .foregroundStyle(ColorHandler.getColor(for: .white))
                    .font(FontHandler.setFont(.bold, size: .xl20))
       
            }
        }
        .frame(width: dw(0.8), height: dh(0.07))
    }
}

private extension PostInsightView {
    //MARK: - Sheet View -
    var sheetView: some View {
        VStack {
            sheetTopRectangleView
            /// Title
            Text("More Settings")
                .foregroundStyle(ColorHandler.getColor(for: .white))
                .font(FontHandler.setFont(.bold, size: .l18))
            
            dividerView
            sheetContentView
            Spacer()
        }
        .frame(width: dw(1))
        .background(BackgroundView())
    }
    
    var sheetContentView: some View {
        VStack {
            /// Copy Caption Automatically
            HStack {
                VStack(alignment: .leading) {
                    Text("Copy caption automatically")
                        .font(FontHandler.setFont(.bold, size: .m16))
                    Text("Copying the caption to your clipboard, allows you to paste it to instagram manually")
                        .font(FontHandler.setFont(.light, size: .xS13))
                        .opacity(0.5)
                }
                Spacer()
                Toggle("", isOn: $vm.isCopyCaptioned)
                    .frame(width: dw(0.16))
                    .tint(ColorHandler.getColor(for: .purple))
            }
            /// Caption
            HStack {
                VStack(alignment: .leading) {
                    Text("Caption")
                        .font(FontHandler.setFont(.bold, size: .m16))
                    Text(vm.model.postDescription)
                        .font(FontHandler.setFont(.light, size: .xS13))
                        .opacity(0.5)
                }
                Spacer()
                Button {
                    UIPasteboard.general.string = vm.model.postDescription
                } label: {
                    ImageHandler.shared.getIcons(.boldArrow)
                        .scaledToFit()
                        .frame(width: dw(0.16), height: dh(0.03))
                }
            }
            
        }
        .frame(width: dw(0.9))
        .foregroundStyle(ColorHandler.getColor(for: .white))
        .onDisappear {
            UserStandard.set(vm.isCopyCaptioned, forKey: UserStandardKey.isCopyCaptionAutoKey)
        }
    }
    
}

private extension PostInsightView {
    //MARK: - Reposting Sheet View -
    var repostingSheet: some View {
        VStack {
            sheetTopRectangleView
            Text("Content Reposting")
                .font(FontHandler.setFont(.bold, size: .l18))
                .padding(.bottom)
            Text("By using this app, you agree to our Terms of Use. You also agree it is your full responsibility to make sure that you have all necessary permissions to share all content that you are reposting. You will not share it without permission from copyright owners. You remain solely responsible for all content you upload.")
                .font(FontHandler.setFont(.light, size: .xS13))
                .opacity(0.5)
                .frame(width: dw(0.9))
            Spacer()
            repostingPostsView
            Spacer()
        }
        .frame(width: dw(1))
        .multilineTextAlignment(.center)
        .foregroundStyle(ColorHandler.getColor(for: .white))
        .background(BackgroundView())
        
    }
    
    var repostingPostsView: some View {
        VStack(spacing: 20) {
            Button {
                withAnimation {
                    vm.isSheetReposting = false
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(ColorHandler.getColor(for: .white))
                        .opacity(0.15)
                    Text("I Disagree")
                        .foregroundStyle(ColorHandler.getColor(for: .red))
                        .font(FontHandler.setFont(.bold, size: .xl20))
           
                }
            }
            .frame(width: dw(0.8), height: dh(0.06))
            
            
            Button {
                withAnimation {
                    vm.isSheetReposting = true
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(ColorHandler.getColor(for: .blue))
                    Text("I Agree")
                        .foregroundStyle(ColorHandler.getColor(for: .white))
                        .font(FontHandler.setFont(.bold, size: .xl20))
           
                }
            }
            .frame(width: dw(0.8), height: dh(0.06))
        }
    }
    
}


private extension PostInsightView {
    //MARK: - Divider View  -
    var dividerView: some View {
        Rectangle()
            .foregroundStyle(ColorHandler.getColor(for: .white))
            .opacity(0.3)
            .frame(height: 1)
    }
    //MARK: - Sheet Top Rectangle View -
    var sheetTopRectangleView: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(ColorHandler.getColor(for: .white))
            .frame(width: dw(0.16), height: dh(0.01))
            .opacity(0.4)
            .padding(.vertical)
    }
}
