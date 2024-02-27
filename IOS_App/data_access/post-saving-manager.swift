//
//  file-manager.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 27.02.2024.
//

import Foundation

class PostSavingManager {
    private static func getPostsFileUrl() -> URL? {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let postsFileUrl = documentDirectoryUrl.appendingPathComponent("Posts.json")
        
        return postsFileUrl
    }
    
    private static let postsFileUrl = getPostsFileUrl()
    
    
    static func write(_ posts: [Post]) {
        do {
            if let fileUrl = postsFileUrl {
                let data = try JSONEncoder().encode(posts)
                
                try data.write(to: fileUrl)
            }
        } catch {
            print("Error encoding and saving posts: \(error.localizedDescription)")
        }
    }

    static func save(_ post: Post) -> Bool {
        var savedPosts = readAll()
        
        if (isSaved(postName: post.name, in: savedPosts)) {
            print("Post \(post.name) is already saved.")
            
            return false
        }
        
        savedPosts.append(post)
        
        write(savedPosts)
        
        return true
    }

    static func delete(_ post: Post) -> Bool {
        var savedPosts = readAll()
        
        if (!isSaved(postName: post.name, in: savedPosts)) {
            print("Post \(post.name) is not saved.")
            
            return false
        }
        
        savedPosts.removeAll(where: {$0.name == post.name})
        
        write(savedPosts)
        
        return true
    }

    static func readAll() -> [Post] {
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

    static func isSaved(postName: String, in posts: [Post]) -> Bool {
        return posts.contains(where: {$0.name == postName})
    }

    static func isSaved(postName: String) -> Bool {
        return isSaved(postName: postName, in: readAll())
    }
}
