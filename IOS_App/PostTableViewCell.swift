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
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.cellLabel.text = "hi there"
//    }
    
    func config(with data: Post) {
        self.postView.config(with: data)
    }
}

