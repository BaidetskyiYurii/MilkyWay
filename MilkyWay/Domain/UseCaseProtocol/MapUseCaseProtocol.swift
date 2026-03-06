//
//  MapUseCaseProtocol.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import Foundation

protocol MapUseCaseProtocol {    
    // Map Route methods
    func insertRoute(_ route: MapRoute) async throws
    func fetchAllRoutes() async throws -> [MapRoute]
    func fetchRoute(with id: String) async throws -> MapRoute?
    
    func deleteRoute(with id: String) async throws
    func deleteAllRoutes() async throws
    
    func updateRoute(id: String, using updates: (MapRouteDTO) -> Void) async throws
}
