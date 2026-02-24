//
//  MKCoordinateRegion+Extensions.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 24.02.2026.
//

import MapKit

extension MKCoordinateRegion {
    /// Creates a region that fits all coordinates with some padding.
    init(coordinates: [CLLocationCoordinate2D], paddingFactor: Double = 1.2) {
        guard let first = coordinates.first else {
            self = MKCoordinateRegion()
            return
        }

        var minLat = first.latitude
        var maxLat = first.latitude
        var minLon = first.longitude
        var maxLon = first.longitude

        for c in coordinates {
            minLat = min(minLat, c.latitude)
            maxLat = max(maxLat, c.latitude)
            minLon = min(minLon, c.longitude)
            maxLon = max(maxLon, c.longitude)
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        // Add padding so polyline isn't touching the edges
        var span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * paddingFactor,
            longitudeDelta: (maxLon - minLon) * paddingFactor
        )

        // Prevent "zero span" (e.g., only 1 point)
        span.latitudeDelta = max(span.latitudeDelta, 0.005)
        span.longitudeDelta = max(span.longitudeDelta, 0.005)

        self.init(center: center, span: span)
    }
}
