//
//  PostView.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 20.02.2024.
//

import UIKit
import Kingfisher

class PostView: UIView {
    private weak var postViewDelegate: PostViewDelegate?
    
    let kCONTENT_XIB_NAME = "PostView"
    
    @IBOutlet var postView: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var post: Post?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        postView.fixInView(self)
    }
    
    
    func config(with post: Post, delegate: PostViewDelegate?) {
        self.post = post
        self.postViewDelegate = delegate
        
        let passed = self.hoursPassed(Date.init(timeIntervalSince1970: Double(post.createdUtc)))
        let imageURl = post.preview?.images.first?.source.url.replacing("&amp;", with: "&")
        
        self.usernameLabel.text = post.author
        self.titleLabel.text = post.title
        self.timeLabel.text = passed
        self.domainLabel.text = post.domain
        self.ratingButton.setTitle("\(post.ups + post.downs)", for: .normal)
        self.commentsButton.setTitle("\(post.numComments)", for: .normal)
        self.image.kf.setImage(with: URL(string: imageURl ?? ""), placeholder: UIImage(named: "photo_2023-10-29_22-48-32"))
        
        self.updateSaveButtonImage(for: post)
        
        self.shareButton.addTarget(
            self,
            action: #selector(self.handleSharing),
            for: .touchUpInside)
        
        self.saveButton.addTarget(
            self,
            action: #selector(self.handleSaving),
            for: .touchUpInside)
    }
    
    func updateSaveButtonImage(for post: Post) {
        self.saveButton.setImage(
            post.isSaved() ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"),
             for: .normal)
    }
    
    @objc
    func handleSharing() {
        guard
            let postViewDelegate = self.postViewDelegate,
            let post = self.post,
            let postUrl = URL(string: "\(baseRedditUrl)\(post.permalink)")
        else {
            return
        }
        
        postViewDelegate.sharePost(url: postUrl)
    }
    
    @objc
    func handleSaving() {
        guard
            let postViewDelegate = self.postViewDelegate,
            let post = self.post
        else {
            return
        }
        
        postViewDelegate.toggleSavePost(post)
    }
    
    private func hoursPassed(_ createdDate: Date) -> String {
        let distanceHours: Int = Int(createdDate.distance(to: Date()) / 3600)
        
        if distanceHours < 24 {
            return "\(distanceHours)h"
        }
        
        return "\(Int(Double(distanceHours) / 24.0))d"
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
