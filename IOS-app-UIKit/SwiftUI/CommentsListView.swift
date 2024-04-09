//
//  CommentsList.swift
//  IOS-app-SwiftUI
//
//  Created by Kathryn Verkhogliad on 31.03.2024.
//

import SwiftUI

struct CommentsListView: View {
    private let fetchCommentsUrl = buildCommentsURL(postId: "1brhnir")
    
    @State var comments: [Comment] = []
    @State var isLoadingData: Bool = false
    @State var fetchError: Bool = false
    
    var body: some View {
        NavigationStack {
            if self.isLoadingData {
                VStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                    Text("Loading...")
                }
            }
            else if self.fetchError {
                Text("Error occured when loading comments.")
            }
            else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(self.comments, id: \.id) { comment in
                            NavigationLink(
                                value: comment,
                                label: {CommentCellView(for: comment)}
                            )
                            .buttonStyle(PlainButtonStyle())
                            Spacer().frame(height: 10.0)
                        }
                    }
                }
                .navigationDestination(
                    for: Comment.self,
                    destination: {CommentDetailsView(for: $0)}
                )
            }
        }
        .onAppear {
            self.getComments()
        }
    }
    
    private func getComments() {
        self.isLoadingData = true
        
        fetchComments(from: self.fetchCommentsUrl, completionHandler: {
            switch $0 {
            case .success(let comments):
                self.comments = comments
            case .failure(let error):
                self.fetchError = true
                print(error.localizedDescription)
            }
            
            self.isLoadingData = false
        })
    }
}
