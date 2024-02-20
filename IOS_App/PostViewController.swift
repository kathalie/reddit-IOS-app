//
//  ViewController.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 10.02.2024.
//

import UIKit
import Kingfisher

class PostViewController: UIViewController {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timePassed: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var bookmark: UIButton!
    @IBOutlet weak var rating: UIButton!
    @IBOutlet weak var comments: UIButton!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = buildURL(urlBody: url)
        
        fetchPosts(from: url, completionHandler: {
            switch $0 {
            case .success(let posts):
                self.processPosts(posts)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func processPosts(_ posts: [Post]) {
        guard let post = posts.first else {
            print("There are no posts fetched.")
            return
        }

        let passed = self.hoursPassed(Date.init(timeIntervalSince1970: Double(post.createdUtc)))
        let imageURl = post.preview?.images.first?.source.url.replacing("&amp;", with: "&")

        DispatchQueue.main.async {
            self.username.text = post.author
            self.postTitle.text = post.title
            self.timePassed.text = passed
            self.domain.text = post.domain
            self.bookmark.setImage(
                post.saved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"),
                 for: .normal)
            self.rating.setTitle("\(post.ups + post.downs)", for: .normal)
            self.comments.setTitle("\(post.numComments)", for: .normal)
            self.image.kf.setImage(with: URL(string: imageURl ?? ""), placeholder: UIImage(named: "photo_2023-10-29_22-48-32"))

        }
    }
    
    private func hoursPassed(_ createdDate: Date) -> String {
        let distanceHours: Int = Int(createdDate.distance(to: Date()) / 3600)
        
        if distanceHours < 24 {
            return "\(distanceHours)h"
        }
        
        return "\(Int(Double(distanceHours) / 24.0))d"
    }
}
