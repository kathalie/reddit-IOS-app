//
//  fetch.swift
//  IOS_App
//
//  Created by Kathryn Verkhogliad on 13.02.2024.
//

import Foundation

let url = URL(string: "https://www.reddit.com/r/ios/top.json?limit=1")!

func fetchPost(by url: URL) async {
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        print(data)
        // more code to come
    } catch {
        print("Invalid data")
    }
    
}
