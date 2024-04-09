//
//  PostDetailsViewController.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 20.02.2024.
//



import Foundation
import UIKit
import SwiftUI

class PostDetailsViewController: UIViewController, PostViewDelegate {
    @IBOutlet private weak var commentsView: UIView!
    @IBOutlet private weak var postView: PostView!
    
    private var updateTableDelegate: PostListViewController?
    private var post: Post?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let post = self.post else {
            return
        }
        
        self.postView.config(with: post, delegate: self)
        
        self.addCommentsListView(to: post)
    }
    
    private func addCommentsListView(to post: Post) {
        
        
        let swiftUiViewController: UIViewController = UIHostingController(rootView: CommentsListView())
        
        let swiftUiView: UIView = swiftUiViewController.view
        
        
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
