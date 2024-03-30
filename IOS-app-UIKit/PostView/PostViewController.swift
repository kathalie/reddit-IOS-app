//
//  PostViewController.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 27.02.2024.
//

import Foundation
import UIKit

class PostViewController: UIViewController, PostViewDelegate {
    func sharePost(url: URL) {
        let items = [url]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        present(ac, animated: true)
    }
}


