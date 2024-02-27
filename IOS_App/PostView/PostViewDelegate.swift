//
//  PostViewDelegate.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 27.02.2024.
//

import Foundation
import UIKit

protocol PostViewDelegate: UIViewController {
    func sharePost(url: URL)
}

extension PostViewDelegate {
    func sharePost(url: URL) {
        let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        present(ac, animated: true)
    }
}
