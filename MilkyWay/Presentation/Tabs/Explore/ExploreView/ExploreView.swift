//
//  ExploreView.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 18.02.2026.
//

import SwiftUI

struct ExploreView: View {
    let testTexts = Array(1...100).map { "Test text \($0)" }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(testTexts, id: \.self) { text in
                    Text(text)
                        .font(.body)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.vertical)
        }
        .background(Color.mwBackground)
        .navigationTitle("100 Test Texts")
    }
}

#Preview {
    ExploreView()
}
