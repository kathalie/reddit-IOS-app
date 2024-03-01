//
//  PostView.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 20.02.2024.
//

import UIKit
import Kingfisher

class PostView: UIView {
    enum Const {
        static let bookmarkWidth = 30.0
        static let bookmarkHeight = 50.0
        static let bookmarkAnimationName = "bookmark_animation"
        static let timeToAppear = 0.4
        static let timeToBecomeStable = 0.4
        static let timeToDisappear = 0.4
    }
    
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
    @IBOutlet weak var animatedBookmark: UIView!
    
    private var post: Post?
    private var bookmarkAnimationCompleted: Bool = true
    
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
        self.image.kf.setImage(
            with: URL(string: imageURl ?? ""),
            placeholder: UIImage(named: "photo_2023-10-29_22-48-32")
        )
        
        self.updateSaveButtonImage(for: post)
        
        self.shareButton.addTarget(
            self,
            action: #selector(self.handleSharing),
            for: .touchUpInside)
        
        self.saveButton.addTarget(
            self,
            action: #selector(self.handleSaving),
            for: .touchUpInside)
        
        let doubleTapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(savePostWithAnimation))
        doubleTapRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapRecognizer)
        
        self.drawAnimatedBookmark()
    }
    
    func updateSaveButtonImage(for post: Post) {
        setSaveButtonImage(for: self.saveButton, isSaved: post.isSaved())
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
    
    @objc
    func savePostWithAnimation(_ sender: UITapGestureRecognizer) {
        if !self.bookmarkAnimationCompleted {
            return
        }
        
        self.playBookmarkAnimation(sender)
        
//        if let postViewDelegate = self.postViewDelegate, let post {
//            if !post.isSaved() {
//                postViewDelegate.toggleSavePost(post)
//            }
//        }
    }
    
    private func playBookmarkAnimation(_ sender: UITapGestureRecognizer) {
        self.bookmarkAnimationCompleted = false
        
        let tapLocation = sender.location(in: self)
        
        self.animatedBookmark.frame.origin = CGPoint(
            x: tapLocation.x - Const.bookmarkWidth / 2,
            y: tapLocation.y - Const.bookmarkHeight / 2)
        

//        DispatchQueue.main.async {
//            UIView.transition(
//                with: self,
//                duration: Const.timeToAppear,
//                options: .transitionCrossDissolve
//            ) {
//                self.animatedBookmark.isHidden = false
//            }
//            UIView.animate(withDuration: Const.timeToAppear) {
//                self.animatedBookmark.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//            }
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + Const.timeToAppear) {
//            UIView.animate(withDuration: Const.timeToBecomeStable) {
//                self.animatedBookmark.transform = CGAffineTransform.identity
//            }
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + Const.timeToAppear + Const.timeToBecomeStable) {
//            UIView.animate(withDuration: Const.timeToDisappear) {
//                self.animatedBookmark.frame.origin = CGPoint(
//                    x: tapLocation.x - Const.bookmarkWidth / 2,
//                    y: self.image.frame.maxY)
//            }
//            UIView.transition(
//                with: self,
//                duration: Const.timeToDisappear,
//                options: .transitionCrossDissolve
//            ) {
//                self.animatedBookmark.isHidden = true
//            }
//        }
        
        
        self.animatedBookmark.isHidden = false
        self.animatedBookmark.layer.opacity = 0
        
        UIView.animate(withDuration: Const.timeToAppear) {
            self.animatedBookmark.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.animatedBookmark.layer.opacity = 1
        } completion: { _ in
            UIView.animate(withDuration: Const.timeToBecomeStable) {
                self.animatedBookmark.transform = CGAffineTransform.identity
            } completion: { _ in
                UIView.animate(withDuration: Const.timeToDisappear) {
                    self.animatedBookmark.frame.origin = CGPoint(
                        x: tapLocation.x - Const.bookmarkWidth / 2,
                        y: self.image.frame.maxY)
                    self.animatedBookmark.layer.opacity = 0
                }
                
                completion: { _ in
                    self.animatedBookmark.isHidden = true
                    
                    self.bookmarkAnimationCompleted = true
                }
            }
        }
    }

    private func drawAnimatedBookmark() {
        self.animatedBookmark.layer.sublayers?.forEach{$0.removeFromSuperlayer()}
        
        self.animatedBookmark.frame.size = CGSize(width: Const.bookmarkWidth, height: Const.bookmarkHeight)
        
        let path = UIBezierPath()

        let cornerRadius = 5.0
        
        path.move(to: CGPoint(x: 0.0, y: Const.bookmarkHeight))
        path.addArc(
            withCenter: CGPoint(x: cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: CGFloat.pi,
            endAngle: 3 * CGFloat.pi / 2,
            clockwise: true)
        path.addArc(
            withCenter: CGPoint(x: Const.bookmarkWidth - cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: 3 * CGFloat.pi / 2,
            endAngle: 0,
            clockwise: true)
        path.addLine(to: CGPoint(x: Const.bookmarkWidth, y: Const.bookmarkHeight))
        path.addLine(to: CGPoint(x: Const.bookmarkWidth / 2, y: 2 * Const.bookmarkHeight / 3))
        path.addLine(to: CGPoint(x: 0.0, y: Const.bookmarkHeight))
        path.close()
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = UIColor.systemPink.cgColor
        shape.lineWidth = 0
        
        self.animatedBookmark.layer.addSublayer(shape)
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
