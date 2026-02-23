//
//  MapItemDTO.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 19.02.2026.
//

import Foundation
import SwiftData

@Model
final class MapItemDTO {
    var id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(
        id: UUID,
        name: String,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init(from protected: MapItem) {
        self.init(
            id: protected.id,
            name: protected.name,
            latitude: protected.latitude,
            longitude: protected.longitude
        )
    }
}

extension MapItemDTO {
    @MainActor
    static let preview: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(
                for: MapItemDTO.self,
                configurations: config
            )

            let item = MapItemDTO(
                id: UUID(),
                name: "Paris 123",
                latitude: 48.856788,
                longitude: 2.351077
            )

            container.mainContext.insert(item)
            try container.mainContext.save()

            return container

        } catch {
            fatalError("Preview container failed: \(error)")
        }
    }()
}
