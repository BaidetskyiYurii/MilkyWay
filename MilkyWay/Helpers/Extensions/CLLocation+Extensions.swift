//
//  CLLocation+Extensions.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 03.05.2026.
//

import CoreLocation

extension Array where Element == CLLocation {
    /// Calculate total distance traveled along the array of locations
    /// - Returns: Total distance in meters
    func totalDistance() -> Double {
        guard count > 1 else { return 0.0 }
        
        var distance: Double = 0.0
        for i in 0..<(count - 1) {
            distance += self[i].distance(from: self[i + 1])
        }
        return distance
    }
    
    /// Calculate total distance in kilometers, formatted as a string
    /// - Parameter format: String format (default: "%.2f")
    /// - Returns: Formatted distance string
    func formattedDistance(format: String = "%.2f") -> String {
        let km = totalDistance() / 1000.0
        return String(format: format, km)
    }
}
