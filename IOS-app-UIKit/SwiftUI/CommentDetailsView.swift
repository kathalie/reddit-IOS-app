//
//  CommentDetails.swift
//  IOS-app-SwiftUI
//
//  Created by Kathryn Verkhogliad on 31.03.2024.
//

import SwiftUI

struct CommentDetailsView: View {
    let username: String
    let timeCreated: String
    let commentText: String
    let rating: String
    let commentLink: URL
    
    init(for comment: Comment) {
        self.username = comment.author
        self.timeCreated = Date.init(timeIntervalSince1970: Double(comment.createdUtc)).formatted(date: .numeric, time: .standard)
        self.commentText = comment.body
        self.rating = String(comment.ups - comment.downs)
        self.commentLink = baseRedditUrl
            .appending(path: comment.permalink)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                SecondaryText(self.username)
                HLineSeparator()
                SecondaryText(self.timeCreated)
            }
            Spacer()
            ScrollView {
                Text(self.commentText)
                    .font(.system(size: 18.0))
                    .fontWeight(.light)
            }
            .padding(.top, 28.0)
            (
                Text("Rating: ")
                + Text(self.rating)
                    .foregroundStyle(Color("AccentColor"))
            )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 16.0)
            ShareLink("Share comment", item: self.commentLink)
                .padding(16.0)
                .frame(maxWidth: .infinity)
                .overlay {
                    RoundedRectangle(
                        cornerRadius: 15.0
                    ).stroke(Color("AccentColor"))
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 36.0)
        .padding(.horizontal, 24.0)
        .background(Color("BackgroundAccentColor"))
        .cornerRadius(20.0)
    }
}

#Preview {
    CommentDetailsView(
        for: Comment(
            id: "kx92rm8",
            author: "SpezIsaSpigger",
            createdUtc: 1711806126,
//            body: "Fresh install of AdGuard?\n\nTry clearing history and website data, then go back into AdGuard and update the filter lists (stay in-app until it’s done updating). Also, in safari you can press the extension icon on the left side of the url bar to make sure AdGuard has permissions setup. [This](https://d3ward.github.io/toolz/adblock.html) is a decent benchmark to test if it’s working or not. If all else fails you can try and select more filters from the safari protection tab in the AdGuard app. Probably just needs a filter update though, iirc the app has to fetch them *at least once* after a fresh install.Fresh install of AdGuard?\n\nTry clearing history and website data, then go back into AdGuard and update the filter lists (stay in-app until it’s done updating). Also, in safari you can press the extension icon on the left side of the url bar to make sure AdGuard has permissions setup. [This](https://d3ward.github.io/toolz/adblock.html) is a decent benchmark to test if it’s working or not. If all else fails you can try and select more filters from the safari protection tab in the AdGuard app. Probably just needs a filter update though, iirc the app has to fetch them *at least once* after a fresh install.",
            body: "Twitter",
            ups: 5,
            downs: 6,
            permalink: "/r/ios/comments/1brhnir/i_have_adguard_but_websites_are_still_infested/kx92rm8/"
        )
    )
}
