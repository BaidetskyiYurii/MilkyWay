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
        guard manager.authorizationStatus == .authorizedAlways else { return }
        manager.startUpdatingLocation()
    }
    
    func startRecording() {
        guard manager.authorizationStatus == .authorizedAlways else { return }
        recordedLocations.removeAll()
        isRecording = true
        manager.startUpdatingLocation()
    }

    func stopRecording() {
        isRecording = false
        manager.stopUpdatingLocation()
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
           
           if isRecording && location.horizontalAccuracy < 20 {
               recordedLocations.append(location)
           }
       }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Log.debug("locationManager didFailWithError: \(error.localizedDescription)")
    }
}
