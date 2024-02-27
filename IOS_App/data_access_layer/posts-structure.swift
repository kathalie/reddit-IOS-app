//
//  posts-structure.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 13.02.2024.
//

import Foundation

struct Source: Decodable {
    let url: String
}

struct Image: Decodable {
    let source: Source
}

struct Preview: Decodable {
    let images: [Image]
}

struct Post: Decodable {
    let permalink: String
    let name: String
    let author: String
    let domain: String
    let createdUtc: Int
    let title: String
    let numComments: Int
    let ups: Int
    let downs: Int
    var saved: Bool = Int.random(in: 0..<2) == 0 ? false : true
    let preview: Preview?
}

struct PostWrappper: Decodable {
    var data: Post
}

struct Posts: Decodable {
    let children: [PostWrappper]
}

struct RedditData: Decodable {
    let data: Posts
}
