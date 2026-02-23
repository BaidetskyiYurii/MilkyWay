//
//  MockHomeUseCase.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation

final class MockHomeUseCase {
    
    // MARK: - Properties
    private let repository: MapRepositoryProtocol
    
    // MARK: - Init methods
    init(repository: MapRepositoryProtocol) {
        self.repository = repository
    }
}

// MARK: - Interface methods
extension MockHomeUseCase: MapUseCaseProtocol {
    func insert(_ item: MapItem) async throws {
        
    }
    
    func fetchMapItems() throws -> [MapItem] {
        []
    }
    
    func fetchPosts(query: String?) async throws -> [Post] {
        return [.dummy, .dummy, .dummy]
    }
}
