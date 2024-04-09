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
    @IBOutlet private weak var postView: PostView!
    @IBOutlet private weak var commentsView: UIView!
    
    private var updateTableDelegate: PostListViewController?
    private var post: Post?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let post = self.post else {
            return
        }
        
        self.postView.config(with: post, delegate: self)
        
        self.addCommentsListView(for: post.id)
    }
    
    private func addCommentsListView(for postId: String) {
        let swiftUiViewController: UIViewController = UIHostingController(rootView: CommentsListView(for: postId))
        
        let swiftUiView: UIView = swiftUiViewController.view
        
        self.commentsView.addSubview(swiftUiView)
        
        swiftUiView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            swiftUiView.topAnchor.constraint(equalTo: self.commentsView.topAnchor),
            swiftUiView.bottomAnchor.constraint(equalTo: self.commentsView.bottomAnchor),
            swiftUiView.trailingAnchor.constraint(equalTo: self.commentsView.trailingAnchor),
            swiftUiView.leadingAnchor.constraint(equalTo: self.commentsView.leadingAnchor),
        ])
        
        swiftUiViewController.didMove(toParent: self)
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
