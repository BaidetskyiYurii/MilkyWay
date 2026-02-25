//
//  MapRepository.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 19.05.2025.
//

import Foundation

final class MapRepository {
    // MARK: - Properties
    private let api: HomeAPIProtocol
    private let reachability: ReachabilityServiceProtocol
    private let storage: MapStorageProtocol
    
    init(api: HomeAPIProtocol,
         reachability: ReachabilityServiceProtocol,
         storage: MapStorageProtocol) {
        self.api = api
        self.reachability = reachability
        self.storage = storage
    }
}

// MARK: - HomeRepositoryProtocol impementation
extension MapRepository: MapRepositoryProtocol {
    func insertRoute(_ route: MapRoute) async throws {
        try await storage.insertRoute(route)
    }
    
    func fetchAllRoutes() async throws -> [MapRoute] {
        try await storage.fetchAllRoutes()
    }
    
    func fetchRoute(with id: String) async throws -> MapRoute? {
        try await storage.fetchRoute(with: id)
    }
    
    func deleteRoute(with id: String) async throws {
        try await storage.deleteRoute(with: id)
    }
    
    func deleteAllRoutes() async throws {
        try await storage.deleteAllRoutes()
    }
    
    func updateRoute(id: String, using updates: (MapRouteDTO) -> Void) async throws {
        try await storage.updateRoute(id: id, using: updates)
    }
    
    func insert(_ item: MapItem) async throws {
        let _ = try await storage.insert(item)
    }
    
    func fetchMapItems() async throws -> [MapItem] {
        try await storage.fetch()
    }
    
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
