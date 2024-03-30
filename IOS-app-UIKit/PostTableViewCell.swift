//
//  PostTableViewCell.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 19.02.2024.
//

import Foundation
import UIKit

final class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postView: PostView!
    
    func config(with data: Post, postDelegate: PostViewDelegate) {
        self.postView.config(with: data, delegate: postDelegate)
    }
}
