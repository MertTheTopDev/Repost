//
//  Mock.swift
//  PostGram
//
//  Created by Mert Türedü on 6.04.2025.
//

import UIKit

struct Mock {
    
    static let previewHelper = PreviewMock()
    
    struct PreviewMock {
        
        let state: PostGramState = .init()
        
        let posts: [PostModel] = [
            .init(id: "1", image: UIImage(imageLiteralResourceName: "image1"),ownerImage: UIImage(imageLiteralResourceName: "image1"), owner: "Mert",postDescription: "Bu Bi test descriptiondur ve önemli olan bunun çalışmasıdır" ,link: "", cratedAt: Date().toStringDate()),
            .init(id: "2", image: UIImage(imageLiteralResourceName: "image1"),ownerImage: UIImage(imageLiteralResourceName: "image1"), owner: "Mert",postDescription: "Bu Bi test descriptiondur ve önemli olan bunun çalışmasıdır" ,link: "", cratedAt: Date().toStringDate())

        ]
        
    }
    
}
