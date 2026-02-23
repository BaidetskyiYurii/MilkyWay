//
//  MapStorage.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 19.02.2026.
//

import SwiftData
import Foundation

@ModelActor
actor MapStorage: MapStorageProtocol {
    @discardableResult
    func insert(_ item: MapItem) throws -> PersistentIdentifier {
        let model = MapItemDTO(from: item)
        modelContext.insert(model)
        try modelContext.save()
        return model.persistentModelID
    }

    func fetch() throws -> [MapItem] {
        try modelContext
            .fetch(FetchDescriptor<MapItemDTO>())
            .map { MapItem(from: $0) }
    }
}
