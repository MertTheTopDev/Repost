//
//  PostViewModel.swift
//  PostGram
//
//  Created by Mert Türedü on 7.04.2025.
//

import UIKit

class PostViewModel: ObservableObject {
    
    @Published var savedPosts: [PostModel]
    @Published var selectedPost: PostModel?
    @Published var isShownHowToUse: Bool
    private let coreDataManager: CoreDataManager
    
    init(savedPosts: [PostModel] = [],
         selectedPost: PostModel? = nil,
         coreDataManager: CoreDataManager = .shared) {
        self.savedPosts = Mock.previewHelper.posts
        self.isShownHowToUse = UserStandard.isShownHowToUsePost
        self.coreDataManager = coreDataManager
        
        fectchSavedPosts()
//        checkPasteboardForLink()
//        parser()
    }
    
}

extension PostViewModel {
    
    private func parser() {
        let instagramPostURL = "https://www.instagram.com/p/DIJIBcTMpnw/?igsh=MWR1bHJ6dzJ1dTRybQ=="

        InstagramParserManager.shared.parseInstagramPost(from: instagramPostURL) { result in
            switch result {
            case .success(let postModel):
                // Use the populated PostModel
                print("Post by: \(postModel.owner)")
                print("Description: \(postModel.postDescription)")
                
                // Update UI with the post data
                DispatchQueue.main.async { [self] in
                    savedPosts.append(postModel)
                }
                
            case .failure(let error):
                print("Error parsing Instagram post: \(error.localizedDescription)")
            }
        }
    }
    
    private func checkPasteboardForLink() {
        
    
        
         if let string = UIPasteboard.general.string,
            let url = URL(string: string), url.scheme?.contains("http") == true,
            !savedPosts.contains(where: { $0.link == string }){
           
             
             
         }
     }
}
//MARK: - CoreData -
extension PostViewModel {
    func deletePost(_ post: PostModel) {
        if let index = savedPosts.firstIndex(where: { $0.id == post.id }) {
            Task {
                await coreDataManager.deletePost(withID: post.id)
                savedPosts.remove(at: index)
            }
        }
    }
    
    func fectchSavedPosts() {
        Task {
            let fetchedPosts = await coreDataManager.fetchAllPosts()
            savedPosts = fetchedPosts
        }
    }
}
