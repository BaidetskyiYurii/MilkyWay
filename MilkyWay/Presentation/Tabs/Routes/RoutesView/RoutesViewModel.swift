//
//  RoutesViewModel.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 26.02.2026.
//

import Foundation
import SwiftData
import FactoryKit

@Observable
@MainActor
final class RoutesViewModel {
    // MARK: - Properties
    @ObservationIgnored
    private let mapUseCase: MapUseCaseProtocol
    @ObservationIgnored
    var notificationTask: Task<Void, Never>? = nil
    
    // MARK: - Observers
    private(set) var routes: [MapRoute] = []
    
    var isLoading: Bool = false
    var error: Error? = nil
    
    // MARK: - Init methods
    init(mapUseCase: MapUseCaseProtocol) {
        Log.verbose("RoutesViewModel init")
        self.mapUseCase = mapUseCase
        subscribeToNotifications()
    }
    
    deinit {
        Log.verbose("RoutesViewModel deinit")
        notificationTask?.cancel()
        notificationTask = nil
    }
}

// MARK: - Public Methods
extension RoutesViewModel {
    func getAllRoutes() async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let allRoutes = try await mapUseCase.fetchAllRoutes()
            routes = allRoutes
        } catch {
            routes = []
            Log.error("RoutesViewModel getAllRoutes failed: \(error)")
        }
    }
    
    func delete(with routeId: String) async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            try await mapUseCase.deleteRoute(with: routeId)
        } catch {
            isLoading = false
            Log.error("RoutesViewModel delete failed: \(error)")
        }
    }
    
    func subscribeToNotifications() {
        notificationTask = Task {
            for await notification in NotificationCenter.default.notifications(named: ModelContext.didSave) {
                Log.debug("RoutesViewModel notification called \(notification.name)")
                await getAllRoutes()
            }
        }
    }
}
