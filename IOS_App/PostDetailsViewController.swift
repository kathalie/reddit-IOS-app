//
//  PostDetailsViewController.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 20.02.2024.
//



import Foundation
import UIKit

class PostDetailsViewController: UIViewController, PostViewDelegate {
    @IBOutlet weak var postView: PostView!
    private var updateTableDelegate: PostListViewController?
    private var post: Post?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let post = self.post else {
            return
        }
        
        self.postView.config(with: post, delegate: self)
    }
    
    func config(with post: Post?, updateTableDelegate: PostListViewController) {
        self.post = post
        self.updateTableDelegate = updateTableDelegate
    }
    
    func updatePosts() {
        self.updateTableDelegate?.updatePosts()
        
        guard let post = self.post else {
            return
        }
        
        self.postView.updateSaveButtonImage(for: post)
    }
}
