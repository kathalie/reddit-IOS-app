//
//  fetch.swift
//  IOS-app-SwiftUI
//
//  Created by Kathryn Verkhogliad on 31.03.2024.
//

import Foundation

func buildCommentsURL(urlBody: URL = baseRedditUrl, subreddit: String = "/r/ios", postId: String, limit: String = "", after: String = "") -> URL {
    let resUrl =  urlBody
        .appending(path: subreddit)
        .appending(path: "comments")
        .appending(path: postId)
        .appending(path: ".json")
        .appending(queryItems: [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "after", value: after)
        ])
    
    print(resUrl)
    
    return resUrl
}


func fetchComments(from url: URL, completionHandler: @escaping (Result<[Comment], FetchError>) -> Void) -> Void {
    let task = URLSession.shared.dataTask(with: url) {data, _, error in
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
                
        guard 
            let redditArrayData = try? decoder.decode(RedditCommentsDataArray.self, from: data)
        else {
            completionHandler(.failure(.decodingFailed))
            
            return
        }
        
        completionHandler(.success(retrieveComments(from: redditArrayData)))
        
    }
    
    task.resume()
}

fileprivate func retrieveComments(from data: RedditCommentsDataArray) -> [Comment] {
    return data.redditCommentData.data.children.compactMap { $0.data }
}

