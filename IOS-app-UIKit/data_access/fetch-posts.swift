//
//  fetch.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 13.02.2024.
//

import Foundation


func buildURL(urlBody: URL, subreddit: String = "/r/ios", limit: Int = 1, after: String = "") -> URL {
    let resUrl =  urlBody
        .appending(path: subreddit)
        .appending(path: "top.json")
        .appending(queryItems: [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "after", value: after)
        ])
    
    print(resUrl)
    
    return resUrl
}


func fetchPosts(from url: URL, completionHandler: @escaping (Result<[Post], FetchError>) -> Void) -> Void {
    let urlSession = URLSession(configuration: .ephemeral)
    
    let task = urlSession.dataTask(with: url) {data, _, error in
        
        if let _ = error {
            completionHandler(.failure(.fail))
            
            return
        }
        
        guard let data else {
            completionHandler(.failure(.noData))

            return
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
                
        guard let redditData = try? decoder.decode(RedditData.self, from: data)
        else {
            completionHandler(.failure(.decodingFailed))
            
            return
        }
        
        let retrievedPosts = retrievePosts(from: redditData)
        
        completionHandler(.success(retrievedPosts))
    }
    
    task.resume()
}

fileprivate func retrievePosts(from data: RedditData) -> [Post] {
    return data.data.children.map { $0.data }
}
