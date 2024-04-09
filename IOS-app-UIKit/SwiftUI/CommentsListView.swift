//
//  CommentsList.swift
//  IOS-app-SwiftUI
//
//  Created by Kathryn Verkhogliad on 31.03.2024.
//

import SwiftUI

struct CommentsListView: View {
    private let fetchCommentsUrl: URL
    
    @State private var comments: [Comment] = []
    @State private var isLoadingData: Bool = false
    @State private var fetchError: Bool = false
    @State private var detailsFor: Comment?
    
    init(for postId: String) {
        self.fetchCommentsUrl = buildCommentsURL(postId: postId)
    }
    
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
                            Button(action: {
                                self.detailsFor = comment
                            }) {
                                CommentCellView(for: comment)
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer().frame(height: 10.0)
                        }
                    }
                }
                .sheet(isPresented: Binding(
                    get: { self.detailsFor != nil },
                    set: { _ in self.detailsFor = nil }
                )){
                    if let detailsFor = self.detailsFor {
                        CommentDetailsView(for: detailsFor)
                    }
                }
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
