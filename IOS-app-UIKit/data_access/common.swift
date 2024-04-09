//
//  common.swift
//  IOS-app-UIKit
//
//  Created by Kathryn Verkhogliad on 09.04.2024.
//

import Foundation

let baseRedditUrl = URL(string: "https://www.reddit.com")!

enum FetchError: Error {
    case fail
    case noData
    case decodingFailed
}

