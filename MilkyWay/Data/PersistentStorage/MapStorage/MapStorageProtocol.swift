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
    func insert(_ item: MapItem) throws -> PersistentIdentifier
    func fetch() throws -> [MapItem]
}
