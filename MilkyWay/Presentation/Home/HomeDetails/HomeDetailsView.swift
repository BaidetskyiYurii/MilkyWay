//
//  HomeDetailsView.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import SwiftUI

struct HomeDetailsView: View {
    @EnvironmentObject var coordinator: Navigation<HomeFlowCoordinator>
    
    private let post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    var body: some View {
        VStack {
            Text(post.title)
            
            Button("Back to Home View") {
                coordinator().pop()
            }
        }
    }
}

#Preview {
    HomeDetailsView(post: .dummy)
}
