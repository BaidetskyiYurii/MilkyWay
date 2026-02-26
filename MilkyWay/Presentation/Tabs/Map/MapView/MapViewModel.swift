//
//  MapViewModel.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation
import SwiftData
import FactoryKit
import CoreLocation

enum MapViewModelError: Error {
    case isStillRecording
    case notEnoughDataToCreateRoute
}

extension MapViewModelError {
    
    var errorTitle: String {
        switch self {
        case .isStillRecording:
            "Recording in Progress"
            
        case .notEnoughDataToCreateRoute:
            "Not Enough Data"
        }
    }
    
    var errorDescription: String {
        switch self {
        case .isStillRecording:
            "Recording is still in progress. Please stop recording before saving the route."
            
        case .notEnoughDataToCreateRoute:
            "There is not enough location data to create a route. Please record more movement and try again."
        }
    }
}

@Observable
@MainActor
final class MapViewModel {
    // MARK: - Properties
    @ObservationIgnored
    private let mapUseCase: MapUseCaseProtocol
    @ObservationIgnored
    var notificationTask: Task<Void, Never>? = nil
    
    // MARK: - Observers
    private(set) var routes: [MapRoute] = []
    
    var routeIdToZoomIn: String?
    
    var isLoading: Bool = false
    var error: Error? = nil
    var customError: MapViewModelError? = nil
    
    // MARK: - Init methods
    init(mapUseCase: MapUseCaseProtocol) {
        Log.debug("MapViewModel init")
        self.mapUseCase = mapUseCase
        subscribeToNotifications()
    }
    
    deinit {
        Log.debug("MapViewModel deinit")
        notificationTask?.cancel()
        notificationTask = nil
    }
}

// MARK: - Public Methods
extension MapViewModel {    
    func insertNewMapRoute(_ newRoute: MapRoute) async {
        do {
            try await mapUseCase.insertRoute(newRoute)
            
            await MainActor.run {
                routeIdToZoomIn = newRoute.id
            }
          
            Log.debug("MapViewModel newRoute was inserted")
        } catch {
            Log.error("MapViewModel insertNewMapRoute failed: \(error)")
        }
    }
    
    func getAllRoutes() async {
        do {
            let allRoutes = try await mapUseCase.fetchAllRoutes()
            routes = allRoutes
        } catch {
            routes = []
            Log.error("RoutesViewModel getAllRoutes failed: \(error)")
        }
    }
    
    func subscribeToNotifications() {
        notificationTask = Task {
            for await notification in NotificationCenter.default.notifications(named: ModelContext.didSave) {
//                Log.debug("MapViewModel notification called \(notification.name)")
                await getAllRoutes()
            }
        }
    }
    
    func createNewRoute(
        isRecording: Bool,
        startLocation: CLLocation?,
        endLocation: CLLocation?,
        recordedLocations: [CLLocation]
    ) -> MapRoute? {
        guard !isRecording else {
            customError = .isStillRecording
            return nil
        }
        
        guard let startLocation, let endLocation, !recordedLocations.isEmpty else {
            customError = .notEnoughDataToCreateRoute
            return nil
        }
        
        let newRoute = MapRoute(
            id: UUID().uuidString,
            name: "New Route",
            startLocation: .init(from: startLocation),
            endLocation: .init(from: endLocation),
            polylineCoordinates: recordedLocations.map { .init(from: $0) },
            createdAt: Date()
        )
        
        return newRoute
    }
}
