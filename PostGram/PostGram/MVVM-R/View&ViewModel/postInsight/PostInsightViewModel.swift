//
//  PostInsightViewModel.swift
//  PostGram
//
//  Created by Mert Türedü on 7.04.2025.
//

import SwiftUI

class PostInsightViewModel: ObservableObject {
    
    @Published var model: PostModel
    
    @Published var selectedCorner: Alignment
    @Published var selectedColor: UIColor
    /// Sheets
    @Published var isSheetAppear: Bool
    @Published var isSheetReposting: Bool
    
    @Published var isCopyCaptioned: Bool
    
    
    init(
        _ model: PostModel,
        
        selectedCorner: Alignment = .bottomLeading,
        selectedColor: UIColor = .white,
        
        isSheetAppear: Bool = false,
        isSheetReposting: Bool = true
    ) {
        self.model = model
        
        self.selectedCorner = selectedCorner
        self.selectedColor = selectedColor
        
        self.isSheetAppear = isSheetAppear
        self.isSheetReposting = isSheetReposting
        
        self.isCopyCaptioned = UserStandard.isCopyCaptionAuto
    }
    
}

extension PostInsightViewModel {
    func changeColor(_ color: UIColor) {
        withAnimation(.linear) {
            selectedColor = color
        }
    }
    
}
