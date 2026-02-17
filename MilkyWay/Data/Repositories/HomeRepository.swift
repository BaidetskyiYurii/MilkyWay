//
//  HomeRepository.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 19.05.2025.
//

import Foundation

actor HomeRepository {
    // MARK: - Properties
    private let api: HomeAPIProtocol
    private let reachability: ReachabilityProtocol
    
    init(api: HomeAPIProtocol,
         reachability: ReachabilityProtocol) {
        self.api = api
        self.reachability = reachability
    }
}

// MARK: - HomeRepositoryProtocol impementation
extension HomeRepository: HomeRepositoryProtocol {
    func fetchPosts(query: String?) async throws -> [Post] {
        guard reachability.isConnected else {
            throw ReachabilityError.notConnected
        }
        
        let newPosts = try await api
            .fetchPosts(query: query)
            .map { $0.toDomain() }
        return newPosts
    }
}
