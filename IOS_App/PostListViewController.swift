//
//  PostListViewController.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 19.02.2024.
//

import UIKit

class PostListViewController: UITableViewController, PostViewDelegate {
    struct Const {
        static let cellReuseIdentifier = "post_cell"
        static let goToPostDetails = "go_to_post_details"
    }
    @IBOutlet weak var subredditLabel: UILabel!
    @IBOutlet weak var filterSavedButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var posts: [Post] = []
    private var lastSelectedPost: Post?
    private var isLoadingData = false
    private var onlySavedPosts = false
    private var searchQuery = "" {
        didSet {
            let savedPosts = PostSavingManager.readAll()
            self.posts = 
                searchQuery.isEmpty ?
                savedPosts :
                savedPosts.filter{$0.title.lowercased().contains(searchQuery.lowercased())}
        }
    }
    
    
    override func viewDidLoad() {
        self.subredditLabel.text = "r/ios"
        
        self.filterSavedButton.addTarget(
            self,
            action: #selector(handleSavedFiltering),
            for: .touchUpInside
        )
        
        self.searchBar.isHidden = true
    }
    
    @objc
    func handleSavedFiltering() {
        self.onlySavedPosts = !self.onlySavedPosts
        
        setSaveButtonImage(for: self.filterSavedButton, isSaved: self.onlySavedPosts)
        
        if self.onlySavedPosts {
            self.searchBar.isHidden = false
            self.posts = PostSavingManager.readAll()
        }
        else {
            self.searchBar.text = ""
            self.searchBar.isHidden = true
            self.posts = []
            self.processPostsFetch()
        }
        
        
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Const.goToPostDetails:
            let nextVc = segue.destination as! PostDetailsViewController

            nextVc.config(with: self.lastSelectedPost, updateTableDelegate: self)

        default: break
        }
    }

    
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
        
        cell.config(with: post, postDelegate: self)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lastSelectedPost = self.posts[indexPath.row]
        self.performSegue(
            withIdentifier: Const.goToPostDetails,
            sender: nil
        )
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.onlySavedPosts {
            return
        }
        
        let contentSizeHeight = tableView.contentSize.height
        let scrollThreshold = contentSizeHeight - tableView.bounds.size.height

        if scrollView.contentOffset.y > scrollThreshold && !isLoadingData {
            isLoadingData = true
            
            self.processPostsFetch(after: self.posts.last?.name ?? "")
        }
    }
    
    private func processPostsFetch(count n: Int = 20, after name: String = "") {
        let url = buildURL(urlBody: baseRedditUrl, limit: n, after: name)
        
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
    
    func updatePosts() {
        self.tableView.reloadData()
    }

}



extension PostListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchQuery = searchText
        self.tableView.reloadData()
    }
}
