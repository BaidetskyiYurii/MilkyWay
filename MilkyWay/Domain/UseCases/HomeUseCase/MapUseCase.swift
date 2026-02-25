//
//  HomeUseCase.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import Foundation

final class MapUseCase {
    
    // MARK: - Properties
    private let repository: MapRepositoryProtocol
    
    // MARK: - Init methods
    init(repository: MapRepositoryProtocol) {
        self.repository = repository
    }
}

// MARK: - Interface methods
extension MapUseCase: MapUseCaseProtocol {
    func insertRoute(_ route: MapRoute) async throws {
       try await repository.insertRoute(route)
    }
    
    func fetchAllRoutes() async throws -> [MapRoute] {
        try await repository.fetchAllRoutes()
    }
    
    func fetchRoute(with id: String) async throws -> MapRoute? {
        try await repository.fetchRoute(with: id)
    }
    
    func deleteRoute(with id: String) async throws {
        try await repository.deleteRoute(with: id)
    }
    
    func deleteAllRoutes() async throws {
        try await repository.deleteAllRoutes()
    }
    
    func updateRoute(id: String, using updates: (MapRouteDTO) -> Void) async throws {
        try await repository.updateRoute(id: id, using: updates)
    }
    
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
