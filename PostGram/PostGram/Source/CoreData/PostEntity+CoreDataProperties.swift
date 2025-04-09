//
//  PostEntity+CoreDataProperties.swift
//  PostGram
//
//  Created by Mert Türedü on 7.04.2025.
//
//

import Foundation
import CoreData


extension PostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostEntity> {
        return NSFetchRequest<PostEntity>(entityName: "PostEntity")
    }

    @NSManaged public var cratedAt: String?
    @NSManaged public var id: String?
    @NSManaged public var video: Data?
    @NSManaged public var image: Data?
    @NSManaged public var link: String?
    @NSManaged public var owner: String?
    @NSManaged public var ownerImage: Data?
    @NSManaged public var postDescription: String?

}

extension PostEntity : Identifiable {

}
