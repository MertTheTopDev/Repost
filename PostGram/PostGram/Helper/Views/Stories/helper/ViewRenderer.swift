//
//  ViewRenderer.swift
//  PostGram
//
//  Created by Mert Türedü on 9.04.2025.
//
import SwiftUI

struct ViewRenderer {
    static func renderToImage<V: View>(view: V) -> UIImage? {
        let controller = UIHostingController(rootView: view)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
