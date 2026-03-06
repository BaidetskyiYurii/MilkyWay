//
//  MapStorage.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 19.02.2026.
//

import SwiftData
import Foundation

@ModelActor
actor MapStorage {}

// MARK: MapStorageProtocol implementation
extension MapStorage: MapStorageProtocol {
    func fetchRoute(with id: String) throws -> MapRoute? {
        let model = try fetchMapRouteDTO(for: id)
        return MapRoute(from: model)
    }
    
    func deleteRoute(with id: String) throws {
        let model = try fetchMapRouteDTO(for: id)
        modelContext.delete(model)
        try modelContext.save()
    }
    
    func deleteAllRoutes() throws {
        try modelContext.delete(model: MapRouteDTO.self)
    }
    
    func insertRoute(_ route: MapRoute) throws {
        let model = MapRouteDTO(from: route)
        modelContext.insert(model)
        try modelContext.save()
    }
    
    func fetchAllRoutes() throws -> [MapRoute] {
        try modelContext
            .fetch(FetchDescriptor<MapRouteDTO>())
            .map { MapRoute(from: $0) }
    }
    
    func updateRoute(
        id: String,
        using updates: (MapRouteDTO) -> Void
    ) throws {
        let model = try fetchMapRouteDTO(for: id)
        updates(model)
        try modelContext.save()
    }
}


// MARK: Helpers
extension MapStorage {
    func fetchMapRouteDTO(for id: String) throws -> MapRouteDTO {
        let descriptor = FetchDescriptor<MapRouteDTO>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let model = try? modelContext.fetch(descriptor).first else {
            throw PersistenceError.notFound
        }
        
        return model
    }
}
