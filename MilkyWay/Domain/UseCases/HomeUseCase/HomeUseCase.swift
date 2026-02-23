//
//  HomeUseCase.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import Foundation

final class HomeUseCase {
    
    // MARK: - Properties
    private let repository: MapRepositoryProtocol
    
    // MARK: - Init methods
    init(repository: MapRepositoryProtocol) {
        self.repository = repository
    }
}

// MARK: - Interface methods
extension HomeUseCase: MapUseCaseProtocol {
    func insert(_ item: MapItem) async throws {
        try await repository.insert(item)
    }
    
    func fetchMapItems() async throws -> [MapItem] {
        try await repository.fetchMapItems()
    }
    
    func fetchPosts(query: String?) async throws -> [Post] {
        try await repository.fetchPosts(query: query)
    }
}
