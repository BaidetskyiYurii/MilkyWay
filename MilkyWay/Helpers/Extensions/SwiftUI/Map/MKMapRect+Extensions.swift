//
//  MKMapRect+Extensions.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 24.02.2026.
//

import MapKit

extension MKMapRect {
    /// Returns a rect that fits all coordinates, with extra padding in meters.
    static func fitting(_ coordinates: [CLLocationCoordinate2D],
                        paddingMeters: Double = 200) -> MKMapRect? {
        guard !coordinates.isEmpty else { return nil }

        var rect: MKMapRect?

        for coord in coordinates {
            let point = MKMapPoint(coord)
            let pointRect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
            rect = rect.map { $0.union(pointRect) } ?? pointRect
        }

        guard var r = rect else { return nil }

        // Expand by padding in *map points* (meters-like at current scale)
        let pad = paddingMeters
        r = r.insetBy(dx: -pad, dy: -pad)

        // If only 1 point, rect can be too tiny; enforce a minimum visible size.
        let minSize: Double = 500
        if r.size.width < minSize || r.size.height < minSize {
            let cx = r.midX
            let cy = r.midY
            r = MKMapRect(x: cx - minSize/2, y: cy - minSize/2, width: minSize, height: minSize)
        }

        return r
    }
}
