//
//  MockHomeUseCase.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation

final class MockHomeUseCase {
    
    // MARK: - Properties
    private let repository: HomeRepositoryProtocol
    
    // MARK: - Init methods
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
}

// MARK: - Interface methods
extension MockHomeUseCase: HomeUseCaseProtocol {
    func fetchPosts(query: String?) async throws -> [Post] {
        return [.dummy, .dummy, .dummy]
    }
}
