//
//  MapStorageProtocol.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 19.02.2026.
//
import SwiftData
import Foundation

//protocol MapStorageProtocol: ModelActor where SendableModel.Model == Model {
//    associatedtype Model: PersistentModel
//    associatedtype SendableModel: ProtectedModel
//    
//    func insert(_ item: SendableModel) throws  -> PersistentIdentifier
//    func fetch() throws -> [SendableModel]
//}


protocol MapStorageProtocol: ModelActor {    
    func insertRoute(_ route: MapRoute) throws
    
    func fetchAllRoutes() throws -> [MapRoute]
    func fetchRoute(with id: String) throws -> MapRoute?
    
    func deleteRoute(with id: String) throws
    func deleteAllRoutes() throws
    
    func updateRoute(id: String, using updates: (MapRouteDTO) -> Void) throws
}
