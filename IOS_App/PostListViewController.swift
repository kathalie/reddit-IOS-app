//
//  PostListViewController.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 19.02.2024.
//

import UIKit

class PostListViewController: UITableViewController {
    struct Const {
        static let cellReuseIdentifier = "post_cell"
//        static let gotToHelloSegueID = "go_to_hello"
    }
    
    private var posts: [Post] = []
//    private var lastSelectedNumber: Int?
    private var isLoadingData = false
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Const.cellReuseIdentifier,
            for: indexPath
        ) as! PostTableViewCell
        let post = posts[indexPath.row]
        
        
        
        print("\(indexPath.row) : PRINTED : \(post.title)") // TODO remove
        
        
        cell.config(with: post)
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSizeHeight = tableView.contentSize.height
        let scrollThreshold = contentSizeHeight - tableView.bounds.size.height

        if scrollView.contentOffset.y > scrollThreshold && !isLoadingData {
            isLoadingData = true
            
            self.processPostsFetch(count: 20, after: self.posts.last?.name ?? "")
        }
    }
    
    
    private func processPostsFetch(count n: Int, after name: String = "") {
        let url = buildURL(urlBody: url, limit: n, after: name)
        
        fetchPosts(from: url, completionHandler: {
            switch $0 {
            case .success(let posts):
                self.processPosts(posts)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            self.isLoadingData = false
        })
    }
    
    private func processPosts(_ posts: [Post]) {
        print("ADDED: \(posts.map{$0.name})") //TODO remove
        
        
        DispatchQueue.main.async {
            self.posts.append(contentsOf: posts)
            self.tableView.reloadData()
        }
    }
}
