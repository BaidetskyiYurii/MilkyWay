//
//  LocationService.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 23.02.2026.
//

import SwiftUI
import CoreLocation

@MainActor
@Observable
final class LocationService: NSObject {
    @ObservationIgnored
    let manager = CLLocationManager()
    
    var currentLocation: CLLocation?
    var recordedLocations: [CLLocation] = []
    var startLocation: CLLocation?
    var endLocation: CLLocation?
    var isRecording = false
    var isAuthorized = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.activityType = .fitness
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        startUpdating()
        Log.verbose("LocationService init")
    }
    
    deinit {
        Log.verbose("LocationService deinit")
    }
}

// MARK: - Public methods
extension LocationService {

    func requestWhenInUse() {
        manager.requestWhenInUseAuthorization()
    }

    func requestAlways() {
        guard manager.authorizationStatus == .authorizedWhenInUse else { return }
        manager.requestAlwaysAuthorization()
    }

    func startUpdating() {
        guard manager.authorizationStatus == .authorizedAlways else {
            requestWhenInUse()
            return
        }
        manager.startUpdatingLocation()
    }
    
    func startRecording() {
        guard manager.authorizationStatus == .authorizedAlways else { return }
        recordedLocations.removeAll()
        startLocation = nil
        endLocation = nil
        
        isRecording = true
        manager.startUpdatingLocation()
    }

    func stopRecording() {
        isRecording = false
        endLocation = recordedLocations.last
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
           switch manager.authorizationStatus {

           case .authorizedWhenInUse:
               isAuthorized = true
               // Now you may ask for Always
               requestAlways()

           case .authorizedAlways:
               isAuthorized = true
               manager.startUpdatingLocation()

           case .denied, .restricted:
               isAuthorized = false

           case .notDetermined:
               isAuthorized = false
               break

           @unknown default:
               break
           }
       }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else { return }

        currentLocation = location

        guard isRecording else { return }

        // 1️⃣ Accuracy filter
        guard location.horizontalAccuracy > 0,
              location.horizontalAccuracy < 15 else { return }

        // 2️⃣ Speed sanity check
        guard location.speed < 50 else { return }

        // 3️⃣ Minimum distance filter
        if let last = recordedLocations.last {
            let distance = location.distance(from: last)

            // Ignore tiny movements
            guard distance > 3 else { return }

            // Ignore impossible jumps
            if distance > 100 {
                return
            }
        }

        // 4️⃣ Set start if needed
        if startLocation == nil {
            startLocation = location
        }

        recordedLocations.append(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Log.debug("locationManager didFailWithError: \(error.localizedDescription)")
    }
}
