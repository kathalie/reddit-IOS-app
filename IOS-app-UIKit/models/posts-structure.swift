//
//  posts-structure.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 13.02.2024.
//

import Foundation

struct Source: Codable {
    let url: String
}

struct Image: Codable {
    let source: Source
}

struct Preview: Codable {
    let images: [Image]
}

struct Post: Codable {
    let id: String
    let permalink: String
    let name: String
    let author: String
    let domain: String
    let createdUtc: Int
    let title: String
    let numComments: Int
    let ups: Int
    let downs: Int
    let preview: Preview?
}

struct PostWrappper: Codable {
    let data: Post
}

struct Posts: Codable {
    let children: [PostWrappper]
}

struct RedditData: Codable {
    let data: Posts
}

extension Post {
    func isSaved() -> Bool {
        return PostSavingManager.isSaved(postName: self.name)
    }
}
