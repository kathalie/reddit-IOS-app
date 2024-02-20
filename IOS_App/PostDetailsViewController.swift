//
//  PostDetailsViewController.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 20.02.2024.
//



import Foundation
import UIKit

class PostDetailsViewController: UIViewController {
    @IBOutlet weak var postView: PostView!

    func config(with post: Post?) {
        guard let post else {
            return
        }

        self.postView.config(with: post)
    }
}
