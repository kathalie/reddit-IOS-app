//
//  PostViewDelegate.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 27.02.2024.
//

import Foundation
import UIKit

protocol PostViewDelegate: UIViewController {
    var postSavingManager: PostSavingManager {get set}
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
        
        if post.isSaved(in: self.postSavingManager.cachedPosts) {
            self.postSavingManager.removeFromCached(post)
        } else {
            self.postSavingManager.cache(post)
        }

        self.updatePosts()
    }
}
