import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PostGram")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Error saving context: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// Saves a new post to Core Data asynchronously
    /// - Parameter post: The post model to save
    /// - Returns: Boolean indicating success or failure
    func savePost(_ post: PostModel) async -> Bool {
        return await withCheckedContinuation { continuation in
            persistentContainer.performBackgroundTask { [weak self] backgroundContext in
                guard let self = self else {
                    continuation.resume(returning: false)
                    return
                }
                
                let entity = PostEntity(context: backgroundContext)
                
                guard let imageData = post.image.jpegData(compressionQuality: 0.7),
                      let ownerImageData = post.ownerImage.jpegData(compressionQuality: 0.7) else {
                    continuation.resume(returning: false)
                    return
                }
                
                entity.id = post.id
                entity.image = imageData
                entity.video = post.video ?? nil
                entity.ownerImage = ownerImageData
                entity.owner = post.owner
                entity.postDescription = post.postDescription
                entity.link = post.link
                entity.cratedAt = post.cratedAt
                
                do {
                    try backgroundContext.save()
                    continuation.resume(returning: true)
                } catch {
                    print("Error saving post: \(error)")
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
    /// Fetches all posts from Core Data asynchronously
    /// - Returns: Array of PostModel objects sorted by creation date (newest first)
    func fetchAllPosts() async -> [PostModel] {
        return await withCheckedContinuation { continuation in
            persistentContainer.performBackgroundTask { [weak self] backgroundContext in
                guard let self = self else {
                    continuation.resume(returning: [])
                    return
                }
                
                let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
                let sortDescriptor = NSSortDescriptor(key: "cratedAt", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                do {
                    let entities = try backgroundContext.fetch(fetchRequest)
                    let postModels = self.convertToPostModels(entities, in: backgroundContext)
                    continuation.resume(returning: postModels)
                } catch {
                    print("Error fetching posts: \(error)")
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    /// Deletes a post from Core Data asynchronously
    /// - Parameter id: The unique identifier of the post to delete
    /// - Returns: Boolean indicating success or failure
    func deletePost(withID id: String) async -> Bool {
        return await withCheckedContinuation { continuation in
            persistentContainer.performBackgroundTask { backgroundContext in
                let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                
                do {
                    let entities = try backgroundContext.fetch(fetchRequest)
                    
                    if let entityToDelete = entities.first {
                        backgroundContext.delete(entityToDelete)
                        try backgroundContext.save()
                        continuation.resume(returning: true)
                    } else {
                        continuation.resume(returning: false)
                    }
                } catch {
                    print("Error deleting post: \(error)")
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
    /// Checks if a post exists in Core Data asynchronously
    /// - Parameter id: The unique identifier of the post
    /// - Returns: Boolean indicating if the post exists
    func postExists(withID id: String) async -> Bool {
        return await withCheckedContinuation { continuation in
            persistentContainer.performBackgroundTask { backgroundContext in
                let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                
                do {
                    let count = try backgroundContext.count(for: fetchRequest)
                    continuation.resume(returning: count > 0)
                } catch {
                    print("Error checking if post exists: \(error)")
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
    /// Searches for posts with a specific term in the description or owner
    /// - Parameter term: The search term
    /// - Returns: Array of matching PostModel objects
    func searchPosts(withTerm term: String) async -> [PostModel] {
        return await withCheckedContinuation { continuation in
            persistentContainer.performBackgroundTask { [weak self] backgroundContext in
                guard let self = self else {
                    continuation.resume(returning: [])
                    return
                }
                
                let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "postDescription CONTAINS[cd] %@ OR owner CONTAINS[cd] %@", term, term)
                
                do {
                    let entities = try backgroundContext.fetch(fetchRequest)
                    let postModels = self.convertToPostModels(entities, in: backgroundContext)
                    continuation.resume(returning: postModels)
                } catch {
                    print("Error searching posts: \(error)")
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    /// Converts Core Data entities to PostModel objects
    /// - Parameters:
    ///   - entities: Array of PostEntity objects
    ///   - context: The managed object context
    /// - Returns: Array of PostModel objects
    private func convertToPostModels(_ entities: [PostEntity], in context: NSManagedObjectContext) -> [PostModel] {
        var postModels: [PostModel] = []
        
        for entity in entities {
            guard let id = entity.id,
                  let imageData = entity.image,
                  let ownerImageData = entity.ownerImage,
                  let owner = entity.owner,
                  let postDescription = entity.postDescription,
                  let link = entity.link,
                  let createdAt = entity.cratedAt else {
                continue
            }
            let video = entity.video ?? nil
            
            guard let image = UIImage(data: imageData),
                  let ownerImage = UIImage(data: ownerImageData) else {
                continue
            }
            
            
            let postModel = PostModel(
                id: id,
                video: video,
                image: image,
                ownerImage: ownerImage,
                owner: owner,
                postDescription: postDescription,
                link: link,
                cratedAt: createdAt
            )
            
            postModels.append(postModel)
        }
        
        return postModels
    }
    
    /// Deletes all posts from Core Data asynchronously
    /// - Returns: Boolean indicating success or failure
    func deleteAllPosts() async -> Bool {
        return await withCheckedContinuation { continuation in
            persistentContainer.performBackgroundTask { backgroundContext in
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PostEntity.fetchRequest()
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                do {
                    try backgroundContext.execute(batchDeleteRequest)
                    try backgroundContext.save()
                    continuation.resume(returning: true)
                } catch {
                    print("Error deleting all posts: \(error)")
                    continuation.resume(returning: false)
                }
            }
        }
    }
}
