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
    case couldNotSaveTheRoute
}

extension MapViewModelError {
    
    var errorTitle: String {
        switch self {
        case .isStillRecording:
            "Recording in Progress"
        case .notEnoughDataToCreateRoute:
            "Not Enough Data"
        case .couldNotSaveTheRoute:
            "Oops..."
        }
    }
    
    var errorDescription: String {
        switch self {
        case .isStillRecording:
            "Recording is still in progress. Please stop recording before saving the route."
        case .notEnoughDataToCreateRoute:
            "There is not enough location data to create a route. Please record more movement and try again."
        case .couldNotSaveTheRoute:
            "We could now save the route"
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
    
    var isShowFinishRouteSheet: Bool = false
    
    // MARK: - Init methods
    init(mapUseCase: MapUseCaseProtocol) {
        Log.verbose("MapViewModel init")
        self.mapUseCase = mapUseCase
        subscribeToNotifications()
    }
    
    deinit {
        Log.verbose("MapViewModel deinit")
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
                isShowFinishRouteSheet = false
                routeIdToZoomIn = newRoute.id
            }
        } catch {
            await MainActor.run {
                customError = .couldNotSaveTheRoute
            }
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
    ) {
        guard !isRecording else {
            customError = .isStillRecording
            return
        }
        
        guard startLocation != nil,
              endLocation != nil, !recordedLocations.isEmpty else {
            customError = .notEnoughDataToCreateRoute
            return
        }
        
        isShowFinishRouteSheet = true
    }
}
