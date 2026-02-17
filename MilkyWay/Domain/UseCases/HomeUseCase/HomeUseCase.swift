//
//  HomeUseCase.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import Foundation

final class HomeUseCase {
    
    // MARK: - Properties
    private let repository: HomeRepositoryProtocol
    
    // MARK: - Init methods
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
}

// MARK: - Interface methods
extension HomeUseCase: HomeUseCaseProtocol {
    func fetchPosts(query: String?) async throws -> [Post] {
        return try await repository.fetchPosts(query: query)
    }
}
