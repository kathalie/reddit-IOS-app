//
//  helper-views.swift
//  IOS-app-SwiftUI
//
//  Created by Kathryn Verkhogliad on 31.03.2024.
//

import SwiftUI

struct SecondaryText: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(self.text)
            .foregroundStyle(Color("SecondaryColor"))
            .font(.subheadline)
            .fixedSize(horizontal: true, vertical: false)
    }
}

struct HLineSeparator: View {
    var body: some View {
        Rectangle()
            .fill(Color("AccentColor"))
            .frame(height: 0.8)
            .padding(.horizontal, 16.0)
    }
}
