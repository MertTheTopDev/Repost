//
//  ScreenStoriesView.swift
//  PostGram
//
//  Created by Mert Türedü on 8.04.2025.
//

import SwiftUI

struct ScreenStoriesView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var isSharePresented: Bool = false
    @State private var renderedImage: UIImage? = nil
    
    // Store images for each cell based on type
    @State private var images: [String: UIImage] = [:]
    
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
            
            // Content that we'll capture for sharing
            contentView
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
                }
                .id("storiesContent")
            
            Spacer().frame(height: dh(0.04))
            
            // Send button
            SendMassageView {
                captureAndShareImage()
            }
            
            Spacer()
        }
        .frame(width: dw(1))
        .background(BackgroundView())
        // Use SwiftUI's sheet presentation for sharing
        .sheet(isPresented: $isSharePresented) {
            if let image = renderedImage {
                ShareSheet(items: [image])
            }
        }
    }
    
    private var contentView: some View {
        BackgroundStoriesView()
    }
    
    private func captureAndShareImage() {
        // Directly capture the view using UIKit approach
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let contentView = window.rootViewController?.view {
            
            // Find the BackgroundStoriesView and its overlay
            let targetSize = CGSize(width: dw(0.85), height: dh(0.67))
            
            // Use a more reliable approach - create a snapshot directly
            UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
            defer { UIGraphicsEndImageContext() }
            
            // Draw background
            let backgroundRect = CGRect(origin: .zero, size: targetSize)
            if let backgroundContext = UIGraphicsGetCurrentContext() {
                let color = UIColor(ColorHandler.getColor(for: .white))
                backgroundContext.setFillColor(color.cgColor)
                backgroundContext.fill(backgroundRect)
            }
            
            // Overlay the actual photos from our images dictionary
            let capturedImage = drawPhotosOnImage(targetSize: targetSize)
            
            renderedImage = capturedImage
            isSharePresented = true
        }
    }
    
    private func drawPhotosOnImage(targetSize: CGSize) -> UIImage {
        // Create a new context with the target size
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        // Draw white background first
        let backgroundRect = CGRect(origin: .zero, size: targetSize)
        let bgColor = UIColor(ColorHandler.getColor(for: .white))
        bgColor.setFill()
        UIRectFill(backgroundRect)
        
        // Based on the type, draw the images at their correct positions
        switch idType {
        case 1:
            drawImageForType1(targetSize)
        case 2:
            drawImageForType2(targetSize)
        case 3:
            drawImageForType3(targetSize)
        case 4:
            drawImageForType4(targetSize)
        case 5:
            drawImageForType5(targetSize)
        default:
            break
        }
        
        // Get the resulting image
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
    // Helper to get image or default placeholder
    private func getImageOrPlaceholder(for key: String, size: CGSize) -> UIImage {
        if let image = images[key] {
            return image
        } else {
            // Create a placeholder image
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            defer { UIGraphicsEndImageContext() }
            
            let rect = CGRect(origin: .zero, size: size)
            let bgColor = UIColor(ColorHandler.getColor(for: .bg)).withAlphaComponent(0.2)
            bgColor.setFill()
            UIRectFill(rect)
            
            // Draw plus icon and text
            let bgUIColor = UIColor(ColorHandler.getColor(for: .bg))
            let plusIcon = UIImage(systemName: "plus.rectangle")?.withTintColor(bgUIColor)
            let iconSize = CGSize(width: size.width * 0.3, height: size.width * 0.3)
            let iconRect = CGRect(
                x: (size.width - iconSize.width) / 2,
                y: (size.height - iconSize.height) / 2 - 10,
                width: iconSize.width,
                height: iconSize.height
            )
            plusIcon?.draw(in: iconRect)
            
            // Draw "Add Photo" text
            let addPhotoText = "Add Photo" as NSString
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .bold),
                .foregroundColor: bgUIColor
            ]
            let textSize = addPhotoText.size(withAttributes: textAttributes)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: iconRect.maxY + 5,
                width: textSize.width,
                height: textSize.height
            )
            addPhotoText.draw(in: textRect, withAttributes: textAttributes)
            
            return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        }
    }
    
    // Drawing functions for each type
    private func drawImageForType1(_ targetSize: CGSize) {
        let size = CGSize(width: targetSize.width, height: targetSize.height)
        let rect = CGRect(origin: .zero, size: size)
        let image = getImageOrPlaceholder(for: "type1_cell0", size: size)
        image.draw(in: rect)
    }
    
    private func drawImageForType2(_ targetSize: CGSize) {
        let width = targetSize.width / 2
        let height = targetSize.height
        
        let leftRect = CGRect(x: 0, y: 0, width: width, height: height)
        let rightRect = CGRect(x: width, y: 0, width: width, height: height)
        
        let leftImage = getImageOrPlaceholder(for: "type2_cell0", size: leftRect.size)
        let rightImage = getImageOrPlaceholder(for: "type2_cell1", size: rightRect.size)
        
        leftImage.draw(in: leftRect)
        rightImage.draw(in: rightRect)
    }
    
    private func drawImageForType3(_ targetSize: CGSize) {
        let width = targetSize.width / 2
        let height = targetSize.height / 2
        
        // Top row
        let topLeftRect = CGRect(x: 0, y: 0, width: width, height: height)
        let topRightRect = CGRect(x: width, y: 0, width: width, height: height)
        
        // Bottom row (full width)
        let bottomRect = CGRect(x: 0, y: height, width: targetSize.width, height: height)
        
        let topLeftImage = getImageOrPlaceholder(for: "type3_cell0", size: topLeftRect.size)
        let topRightImage = getImageOrPlaceholder(for: "type3_cell1", size: topRightRect.size)
        let bottomImage = getImageOrPlaceholder(for: "type3_cell2", size: bottomRect.size)
        
        topLeftImage.draw(in: topLeftRect)
        topRightImage.draw(in: topRightRect)
        bottomImage.draw(in: bottomRect)
    }
    
    private func drawImageForType4(_ targetSize: CGSize) {
        let width = targetSize.width / 2
        let height = targetSize.height / 2
        
        // Top row
        let topLeftRect = CGRect(x: 0, y: 0, width: width, height: height)
        let topRightRect = CGRect(x: width, y: 0, width: width, height: height)
        
        // Bottom row
        let bottomLeftRect = CGRect(x: 0, y: height, width: width, height: height)
        let bottomRightRect = CGRect(x: width, y: height, width: width, height: height)
        
        let topLeftImage = getImageOrPlaceholder(for: "type4_cell0", size: topLeftRect.size)
        let topRightImage = getImageOrPlaceholder(for: "type4_cell1", size: topRightRect.size)
        let bottomLeftImage = getImageOrPlaceholder(for: "type4_cell2", size: bottomLeftRect.size)
        let bottomRightImage = getImageOrPlaceholder(for: "type4_cell3", size: bottomRightRect.size)
        
        topLeftImage.draw(in: topLeftRect)
        topRightImage.draw(in: topRightRect)
        bottomLeftImage.draw(in: bottomLeftRect)
        bottomRightImage.draw(in: bottomRightRect)
    }
    
    private func drawImageForType5(_ targetSize: CGSize) {
        let width = targetSize.width / 2
        let height = targetSize.height / 3
        
        // First row
        let topLeftRect = CGRect(x: 0, y: 0, width: width, height: height)
        let topRightRect = CGRect(x: width, y: 0, width: width, height: height)
        
        // Second row
        let midLeftRect = CGRect(x: 0, y: height, width: width, height: height)
        let midRightRect = CGRect(x: width, y: height, width: width, height: height)
        
        // Third row
        let bottomLeftRect = CGRect(x: 0, y: height * 2, width: width, height: height)
        let bottomRightRect = CGRect(x: width, y: height * 2, width: width, height: height)
        
        let topLeftImage = getImageOrPlaceholder(for: "type5_cell0", size: topLeftRect.size)
        let topRightImage = getImageOrPlaceholder(for: "type5_cell1", size: topRightRect.size)
        let midLeftImage = getImageOrPlaceholder(for: "type5_cell2", size: midLeftRect.size)
        let midRightImage = getImageOrPlaceholder(for: "type5_cell3", size: midRightRect.size)
        let bottomLeftImage = getImageOrPlaceholder(for: "type5_cell4", size: bottomLeftRect.size)
        let bottomRightImage = getImageOrPlaceholder(for: "type5_cell5", size: bottomRightRect.size)
        
        topLeftImage.draw(in: topLeftRect)
        topRightImage.draw(in: topRightRect)
        midLeftImage.draw(in: midLeftRect)
        midRightImage.draw(in: midRightRect)
        bottomLeftImage.draw(in: bottomLeftRect)
        bottomRightImage.draw(in: bottomRightRect)
    }
}

// ShareSheet is a UIViewControllerRepresentable wrapper for UIActivityViewController
struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ScreenStoriesView(5)
}

private extension ScreenStoriesView {
    
    var type1View: some View {
        ModifiedAddPhotoView(.init(width: 0.85, height: 0.67), key: "type1_cell0") { image in
            self.images["type1_cell0"] = image
        }
    }
    
    var type2View: some View {
        HStack(spacing: 0) {
            ModifiedAddPhotoView(.init(width: 0.425, height: 0.67), key: "type2_cell0") { image in
                self.images["type2_cell0"] = image
            }
            ModifiedAddPhotoView(.init(width: 0.425, height: 0.67), key: "type2_cell1") { image in
                self.images["type2_cell1"] = image
            }
        }
    }
    
     var type3View: some View {
         VStack(spacing: 0) {
             HStack(spacing: 0) {
                 ModifiedAddPhotoView(.init(width: 0.425, height: 0.335), key: "type3_cell0") { image in
                     self.images["type3_cell0"] = image
                 }
                 ModifiedAddPhotoView(.init(width: 0.425, height: 0.335), key: "type3_cell1") { image in
                     self.images["type3_cell1"] = image
                 }
             }
             ModifiedAddPhotoView(.init(width: 0.85, height: 0.335), key: "type3_cell2") { image in
                 self.images["type3_cell2"] = image
             }
         }
    }
    
     var type4View: some View {
         VStack(spacing: 0) {
             HStack(spacing: 0) {
                 ModifiedAddPhotoView(.init(width: 0.425, height: 0.335), key: "type4_cell0") { image in
                     self.images["type4_cell0"] = image
                 }
                 ModifiedAddPhotoView(.init(width: 0.425, height: 0.335), key: "type4_cell1") { image in
                     self.images["type4_cell1"] = image
                 }
             }
             HStack(spacing: 0) {
                 ModifiedAddPhotoView(.init(width: 0.425, height: 0.335), key: "type4_cell2") { image in
                     self.images["type4_cell2"] = image
                 }
                 ModifiedAddPhotoView(.init(width: 0.425, height: 0.335), key: "type4_cell3") { image in
                     self.images["type4_cell3"] = image
                 }
             }
         }
    }
    
    var type5View: some View {
        let size: CGSize = .init(width: 0.42, height: 0.233)
        
        return VStack(spacing: 0) {
            HStack(spacing: 0) {
                ModifiedAddPhotoView(size, key: "type5_cell0") { image in
                    self.images["type5_cell0"] = image
                }
                ModifiedAddPhotoView(size, key: "type5_cell1") { image in
                    self.images["type5_cell1"] = image
                }
            }
            HStack(spacing: 0) {
                ModifiedAddPhotoView(size, key: "type5_cell2") { image in
                    self.images["type5_cell2"] = image
                }
                ModifiedAddPhotoView(size, key: "type5_cell3") { image in
                    self.images["type5_cell3"] = image
                }
            }
            HStack(spacing: 0) {
                ModifiedAddPhotoView(size, key: "type5_cell4") { image in
                    self.images["type5_cell4"] = image
                }
                ModifiedAddPhotoView(size, key: "type5_cell5") { image in
                    self.images["type5_cell5"] = image
                }
            }
        }
    }
}

struct ModifiedAddPhotoView: View {
    @State private var selectedImage: UIImage?
    let size: CGSize
    let key: String
    let onImageSelected: (UIImage) -> Void
    
    init(
        _ size: CGSize,
        key: String,
        onImageSelected: @escaping (UIImage) -> Void
    ) {
        self.size = size
        self.key = key
        self.onImageSelected = onImageSelected
    }
    
    var body: some View {
        Group {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .onAppear {
                        onImageSelected(image)
                    }
            } else {
                addPhotoTemplateView
            }
        }
        .frame(width: dw(size.width), height: dh(size.height))
        .onTapGesture {
            PhotoPickerManager.shared.selectPhoto { image in
                if let image = image {
                    selectedImage = image
                    onImageSelected(image)
                }
            }
        }
    }
    
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
