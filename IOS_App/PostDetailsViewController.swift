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
    private var post: Post?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let post = self.post else {
            return
        }
        
        self.postView.postViewDelegate = self
        self.postView.config(with: post)
    }
    
    func config(with post: Post?) {
        self.post = post
    }
}
