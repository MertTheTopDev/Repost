//
//  PostModel.swift
//  PostGram
//
//  Created by Mert Türedü on 7.04.2025.
//

import UIKit

struct PostModel: Identifiable {
    let id: String
    let video: Data?
    let image: UIImage
    let ownerImage: UIImage
    var owner: String
    let postDescription: String
    let link: String
    let cratedAt: String
    
    init(id: String,
         video: Data? = nil,
         image: UIImage,
         ownerImage: UIImage,
         owner: String,
         postDescription: String,
         link: String,
         cratedAt: String) {
        self.id = id
        self.video = video
        self.image = image
        self.ownerImage = ownerImage
        self.owner = owner
        self.postDescription = postDescription
        self.link = link
        self.cratedAt = cratedAt
    }
}
