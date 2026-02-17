//
//  Network+HomeAPI.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 19.05.2025.
//

import Foundation

extension NetworkService: HomeAPIProtocol where R == HomeRoutes {
    func fetchPosts(query: String?) async throws -> [PostResponseDTO] {
        let requestDTO: FetchPostsRequestDTO = .init(query: query)
        
        return try await self.request(
            .fetchPosts(baseURL, requestDTO),
            target: [PostResponseDTO].self,
            decoder: .apiDecoder
        )
    }
}
