//
//  MapRouteDTO.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 25.02.2026.
//

import Foundation
import SwiftData

struct CoordinateDTO: Codable {
    var id: String
    var latitude: Double
    var longitude: Double

    init(
        id: String,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(from domain: Coordinate) {
        self.init(
            id: domain.id,
            latitude: domain.latitude,
            longitude: domain.longitude
        )
    }
}

@Model
final class MapRouteDTO {
    @Attribute(.unique)
    var id: String
    var name: String
    var startLocation: CoordinateDTO
    var endLocation: CoordinateDTO
    var polylineCoordinates: [CoordinateDTO]
    var createdAt: Date
    
    init(
        id: String,
        name: String,
        startLocation: CoordinateDTO,
        endLocation: CoordinateDTO,
        polylineCoordinates: [CoordinateDTO],
        createdAt: Date
    ) {
        Log.debug("MapRouteDTO created with id \(id)")
        self.id = id
        self.name = name
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.polylineCoordinates = polylineCoordinates
        self.createdAt = createdAt
    }
    
    convenience init(from protected: MapRoute) {
        Log.debug("MapRouteDTO created from protected with id \(protected.id)")
        self.init(
            id: protected.id,
            name: protected.name,
            startLocation: .init(from: protected.startLocation),
            endLocation: .init(from: protected.endLocation),
            polylineCoordinates: protected.polylineCoordinates.map { CoordinateDTO(from: $0) },
            createdAt: protected.createdAt
        )
    }
}

//extension MapItemDTO {
//    @MainActor
//    static let preview: ModelContainer = {
//        do {
//            let config = ModelConfiguration(isStoredInMemoryOnly: true)
//            let container = try ModelContainer(
//                for: MapItemDTO.self,
//                configurations: config
//            )
//
//            let item = MapItemDTO(
//                id: UUID(),
//                name: "Paris 123",
//                latitude: 48.856788,
//                longitude: 2.351077
//            )
//
//            container.mainContext.insert(item)
//            try container.mainContext.save()
//
//            return container
//
//        } catch {
//            fatalError("Preview container failed: \(error)")
//        }
//    }()
//}
//
