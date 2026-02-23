//
//  MapItem.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 19.02.2026.
//

import Foundation
import SwiftData

struct MapItem: Equatable {
    let id: UUID
    let persistentModelID: PersistentIdentifier?
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(
        id: UUID = UUID(),
        persistentModelID: PersistentIdentifier? = nil,
        name: String,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.persistentModelID = persistentModelID
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension MapItem: ProtectedModel {
    init(from item: MapItemDTO) {
        self.init(
            id: item.id,
            persistentModelID: item.persistentModelID,
            name: item.name,
            latitude: item.latitude,
            longitude: item.longitude
        )
    }
}
