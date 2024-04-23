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
    var postSavingManager: PostSavingManager = PostSavingManager() // TODO: it loads extra data
    
    @IBOutlet private weak var postView: PostView!
    @IBOutlet private weak var commentsCotainer: UIView!
    
    private var updateTableDelegate: PostListViewController?
    private var post: Post?
    private var postTapRecognizer: PostTapRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard 
            let post = self.post,
            let postTapRecognizer = self.postTapRecognizer
        else {
            return
        }
        
        self.postView.config(with: post, delegate: self, tapRecognizer: postTapRecognizer)
        
        self.addCommentsListView(for: post.id)
    }
    
    private func addCommentsListView(for postId: String) {
        let swiftUiViewController: UIViewController = UIHostingController(rootView: CommentsListView(for: postId))
        
        let swiftUiView: UIView = swiftUiViewController.view
        
        self.commentsCotainer.addSubview(swiftUiView)
        
        swiftUiView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            swiftUiView.topAnchor.constraint(equalTo: self.commentsCotainer.topAnchor),
            swiftUiView.bottomAnchor.constraint(equalTo: self.commentsCotainer.bottomAnchor),
            swiftUiView.trailingAnchor.constraint(equalTo: self.commentsCotainer.trailingAnchor),
            swiftUiView.leadingAnchor.constraint(equalTo: self.commentsCotainer.leadingAnchor),
        ])
        
        swiftUiViewController.didMove(toParent: self)
    }

    
    func config(with post: Post?, updateTableDelegate: PostListViewController, postTapRecognizer: PostTapRecognizer) {
        self.post = post
        self.postTapRecognizer = postTapRecognizer
        self.updateTableDelegate = updateTableDelegate
        self.postSavingManager = updateTableDelegate.postSavingManager
    }
    
    func updatePosts() {
        self.updateTableDelegate?.updatePosts()
        
        if let post = self.post {
            self.postView.updateSaveButtonImage(for: post)
        }
    }
}
