//
//  PostViewDelegate.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 27.02.2024.
//

import Foundation
import UIKit

protocol PostViewDelegate: UIViewController {
    func sharePost(url: URL)
    func toggleSavePost(_ post: Post)
    func updatePosts()
}

extension PostViewDelegate {
    func sharePost(url: URL) {
        let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        present(ac, animated: true)
    }
    
    func toggleSavePost(_ post: Post) {
        let success = post.isSaved() 
        ? PostSavingManager.delete(post)
        : PostSavingManager.save(post)
        
        print(success ? "Posts updated" : "Failed to update posts")
        print("Current posts count: \(PostSavingManager.readAll().count)")
        
        self.updatePosts()
    }
}
