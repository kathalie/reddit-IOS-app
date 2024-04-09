//
//  comments-structure.swift
//  IOS-app-SwiftUI
//
//  Created by Kathryn Verkhogliad on 31.03.2024.
//

import Foundation

struct Comment: Codable, Hashable {
    let id: String
    let author: String
    let createdUtc: Int
    let body: String
    let ups: Int
    let downs: Int
    let permalink: String
}


struct CommentWrappper: Codable {
    let data: Comment
}

struct Comments: Codable {
    let children: [CommentWrappper]
}

struct RedditCommentData: Codable {
    let data: Comments
}

struct RedditCommentsDataArray: Codable {
    let redditCommentData: RedditCommentData
    
    init(from decoder: Decoder) throws {
        var values = try decoder.unkeyedContainer()
        
        _ = try values.decode(SkippedObject.self)
        self.redditCommentData = try values.decode(RedditCommentData.self)
    }
}

struct SkippedObject: Codable {}
