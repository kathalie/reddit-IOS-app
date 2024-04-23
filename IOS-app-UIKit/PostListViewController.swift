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
        static let goToPostDetails = "go_to_post_details"
    }
    @IBOutlet private weak var subredditLabel: UILabel!
    @IBOutlet private weak var filterSavedButton: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    internal var postSavingManager = PostSavingManager()
    private var filteredPosts: [Post] = []
    private var posts: [Post] = []
    private var lastSelectedPost: Post?
    private var isLoadingData = false
    private var unableToLoadData = false
    private var onlyFilteredPosts = false
    private var searchQuery = "" {
        didSet {
            self.posts = 
                searchQuery.isEmpty ?
                self.filteredPosts :
                self.filteredPosts.filter{$0.title.lowercased().contains(searchQuery.lowercased())}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filteredPosts = self.postSavingManager.cachedPosts
        
        self.addRefreshControl()

        self.subredditLabel.text = "r/ios"
        
        self.filterSavedButton.addTarget(
            self,
            action: #selector(handleSavedFiltering),
            for: .touchUpInside
        )
        
        self.searchBar.isHidden = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(savePostsIntoFile),
            name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc
    private func savePostsIntoFile() {
        self.postSavingManager.saveCache()
    }
    
    private func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        if !self.onlyFilteredPosts {
            self.processPostsLoad()
        }
        
        refreshControl.endRefreshing()
    }
    
    @objc
    func handleSavedFiltering() {
        self.onlyFilteredPosts = !self.onlyFilteredPosts
        
        setSaveButtonImage(for: self.filterSavedButton, isSaved: self.onlyFilteredPosts)
        
        if self.onlyFilteredPosts {
            self.searchBar.isHidden = false
            self.posts = self.filteredPosts
        }
        else {
            self.searchBar.text = ""
            self.searchBar.isHidden = true
            self.searchBar.resignFirstResponder()
            self.posts = []
            self.processPostsLoad()
        }
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Const.goToPostDetails:
            let nextVc = segue.destination as! PostDetailsViewController

            if let lastSelectedPost = self.lastSelectedPost {
                nextVc.config(with: lastSelectedPost, updateTableDelegate: self)
            }

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
        if self.onlyFilteredPosts {
            return
        }
        
        let contentSizeHeight = tableView.contentSize.height
        let scrollThreshold = contentSizeHeight - tableView.bounds.size.height

        if scrollView.contentOffset.y > scrollThreshold && !isLoadingData {
            self.processPostsLoad(after: self.posts.last?.name ?? "")
        }
    }
    
    private func processPostsLoad(count n: Int = 20, after name: String = "") {
        self.isLoadingData = true
        
        let url = buildURL(urlBody: baseRedditUrl, limit: n, after: name)
        
        fetchPosts(from: url, completionHandler: {
            switch $0 {
            case .success(let posts):
                print("ADDED: \(posts.map{$0.name})") //TODO remove
                
                if self.unableToLoadData {
                    self.posts = []
                    self.unableToLoadData = false
                }
                
                self.processPosts(posts)
            case .failure(let error):
                print(error.localizedDescription)
                
                self.unableToLoadData = true
                
                DispatchQueue.main.async {
                    self.posts = self.postSavingManager.cachedPosts
                    self.tableView.reloadData()
                }
            }
            
            self.isLoadingData = false
        })
    }
    
    private func processPosts(_ posts: [Post]) {
        DispatchQueue.main.async {
            self.posts.append(contentsOf: posts)
            self.tableView.reloadData()
        }
    }
}



extension PostListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
            self.searchQuery = searchText
            self.tableView.reloadData()
        }
    }
}

extension PostListViewController: PostViewDelegate {
    func updatePosts() {
        DispatchQueue.main.async {
            self.filteredPosts = self.postSavingManager.cachedPosts
            
            if self.onlyFilteredPosts {
                self.posts = self.postSavingManager.cachedPosts
            }

            self.tableView.reloadData()
        }
    }
}


