//
//  StoriesViewModel.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import Foundation

class StoriesViewModel: ObservableObject {
    @Published var isSheetAppear: Bool = false
    @Published var type: Int? = nil
    @Published var selectedStories: String? = nil
}

extension StoriesViewModel {

}

