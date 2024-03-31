//
//  ContentView.swift
//  IOS-app-SwiftUI
//
//  Created by Kathryn Verkhogliad on 30.03.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Comments")
            .font(.title)
            .padding(.vertical, 12.0)
        CommentsListView()
    }
}

#Preview {
    ContentView()
}
