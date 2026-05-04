//
//  MapRoute.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 25.02.2026.
//

import Foundation
import CoreLocation
import SwiftData

struct Coordinate: Equatable {
    let id: String
//    let persistentModelID: PersistentIdentifier?
    let latitude: Double
    let longitude: Double
    
    init(
        id: String,
//        persistentModelID: PersistentIdentifier? = nil,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
//        self.persistentModelID = persistentModelID
        self.latitude = latitude
        self.longitude = longitude
    }
    
}

extension Coordinate {
    init(from dto: CoordinateDTO) {
//        Log.debug("MapRoute created from DTO with id \(item.id), persistentModelID is \(item.persistentModelID)")
        self.init(
            id: dto.id,
//            persistentModelID: dto.persistentModelID,
            latitude: dto.latitude,
            longitude: dto.longitude
        )
    }
    
    init(from cllocation: CLLocation) {
        self.init(
            id: UUID().uuidString,
            latitude: cllocation.coordinate.latitude,
            longitude: cllocation.coordinate.longitude
        )
    }
    
}

extension Coordinate {
    func toLocationCoordinate() -> CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
}

struct MapRoute: Equatable {
    let id: String
    let persistentModelID: PersistentIdentifier?
    
    let name: String
    let startLocation: Coordinate
    let endLocation: Coordinate
    let polylineCoordinates: [Coordinate]
    let createdAt: Date
    let startDate: Date
    let endDate: Date
    let totalDistanceMeters: Double
    
    init(
        id: String,
        persistentModelID: PersistentIdentifier? = nil,
        name: String,
        startLocation: Coordinate,
        endLocation: Coordinate,
        polylineCoordinates: [Coordinate],
        createdAt: Date,
        startDate: Date,
        endDate: Date,
        totalDistanceMeters: Double
    ) {
        self.id = id
        self.persistentModelID = persistentModelID
        self.name = name
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.polylineCoordinates = polylineCoordinates
        self.createdAt = createdAt
        self.startDate = startDate
        self.endDate = endDate
        self.totalDistanceMeters = totalDistanceMeters
    }
}

extension MapRoute: ProtectedModel {
    init(from item: MapRouteDTO) {
        Log.debug("MapRoute created from DTO with id \(item.id), persistentModelID is \(item.persistentModelID)")
        self.init(
            id: item.id,
            persistentModelID: item.persistentModelID,
            name: item.name,
            startLocation: .init(from: item.startLocation),
            endLocation: .init(from: item.endLocation),
            polylineCoordinates: item.polylineCoordinates.map { .init(from: $0) },
            createdAt: item.createdAt,
            startDate: item.startDate,
            endDate: item.endDate,
            totalDistanceMeters: item.totalDistanceMeters
        )
    }
}

extension CLLocationCoordinate2D {
    init(from dto: CoordinateDTO) {
        self.init(latitude: dto.latitude,
                  longitude: dto.longitude)
    }
}
