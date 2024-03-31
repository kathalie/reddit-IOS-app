//
//  CommentCell.swift
//  IOS-app-SwiftUI
//
//  Created by Kathryn Verkhogliad on 31.03.2024.
//

import SwiftUI

struct CommentCellView: View {
    let username: String
    let timeCreated: String
    let commentText: String
    let rating: Int
    
    init(for comment: Comment) {
        self.username = comment.author
        self.timeCreated = Date.init(timeIntervalSince1970: Double(comment.createdUtc)).formatted(date: .numeric, time: .standard)
        self.commentText = comment.body
        self.rating = comment.ups - comment.downs
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(self.username)
                Text(self.timeCreated)
            }
            Text(self.commentText)
                .lineLimit(1)
            HStack {
                Image(systemName: (self.rating < 0 ? "arrowshape.down" : "arrowshape.up"))
                Text(String(self.rating))
            }
        }
        .frame(maxWidth: .infinity)
        
    }
}

#Preview {
    CommentCellView(for: Comment(
        id: "kx92rm8",
        author: "SpezIsaSpigger",
        createdUtc: 1711806126,
        body: "Fresh install of AdGuard?\n\nTry clearing history and website data, then go back into AdGuard and update the filter lists (stay in-app until it’s done updating). Also, in safari you can press the extension icon on the left side of the url bar to make sure AdGuard has permissions setup. [This](https://d3ward.github.io/toolz/adblock.html) is a decent benchmark to test if it’s working or not. If all else fails you can try and select more filters from the safari protection tab in the AdGuard app. Probably just needs a filter update though, iirc the app has to fetch them *at least once* after a fresh install.",
        ups: 5,
        downs: 6,
        permalink: "/r/ios/comments/1brhnir/i_have_adguard_but_websites_are_still_infested/kx92rm8/"
    ))
}
