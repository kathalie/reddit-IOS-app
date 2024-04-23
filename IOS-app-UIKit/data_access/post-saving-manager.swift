//
//  file-manager.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 27.02.2024.
//

import Foundation

class PostSavingManager {
    private var _cachedPosts = PostSavingManager.readAll()
    
    var cachedPosts: [Post] {
        get {
            _cachedPosts
        }
    }

    func cache(_ post: Post) {
        if let index = self.cachedPosts.firstIndex(where: { post.createdUtc >= $0.createdUtc }) {
            self._cachedPosts.insert(post, at: index)
        } else {
            self._cachedPosts.append(post)
        }
    }
    
    func removeFromCached(_ post: Post) {
        self._cachedPosts.removeAll(where: { $0.id == post.id})
    }
    
    func saveCache() {
        PostSavingManager.write(self.cachedPosts)
    }
    
    
    private static func getPostsFileUrl() -> URL? {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let postsFileUrl = documentDirectoryUrl.appendingPathComponent("Posts.json")
        
        return postsFileUrl
    }
    
    private static let postsFileUrl = getPostsFileUrl()
    
    
    private static func write(_ posts: [Post]) {
        do {
            if let fileUrl = postsFileUrl {
                let data = try JSONEncoder().encode(posts)
                
                try data.write(to: fileUrl)
            }
        } catch {
            print("Error encoding and saving posts: \(error.localizedDescription)")
        }
    }
    
    private static func readAll() -> [Post] {
        do {
            if let fileUrl = postsFileUrl {
                let data = try Data(contentsOf: fileUrl)
                let decodedPosts = try JSONDecoder().decode([Post].self, from: data)
                
                return decodedPosts
            }
        } catch {
            print("Error reading posts: \(error.localizedDescription)")
        }
        
        return []
    }

//    static func save(_ post: Post) -> Bool {
//        var savedPosts = readAll()
//        
//        if (isSaved(postName: post.name, in: savedPosts)) {
//            print("Post \(post.name) is already saved.")
//            
//            return false
//        }
//        
//        savedPosts.insert(post, by: {$0.createdUtc < $1.createdUtc})
//        
//        write(savedPosts)
//        
//        return true
//    }
//    
//    private static func insert(_ post: Post, in posts: inout [Post]) {
//        if let index = posts.firstIndex(where: { $0.createdUtc >= post.createdUtc }) {
//            posts.insert(post, at: index)
//        } else {
//            posts.append(post)
//        }
//    }
//    
//    private static func delete(_ post: Post) -> Bool {
//        var savedPosts = readAll()
//        
//        if (!isSaved(postName: post.name, in: savedPosts)) {
//            print("Post \(post.name) is not saved.")
//            
//            return false
//        }
//        
//        savedPosts.removeAll(where: {$0.name == post.name})
//        
//        write(savedPosts)
//        
//        return true
//    }

//    private static func isSaved(postName: String, in posts: [Post]) -> Bool {
//        return posts.contains(where: {$0.name == postName})
//    }
//
//    private static func isSaved(postName: String) -> Bool {
//        return isSaved(postName: postName, in: readAll())
//    }
}
