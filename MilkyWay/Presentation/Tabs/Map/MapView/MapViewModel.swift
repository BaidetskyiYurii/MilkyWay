//
//  MapViewModel.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation
import SwiftData
import FactoryKit

@Observable
@MainActor
final class MapViewModel {
    // MARK: - Properties
    @ObservationIgnored
    private let mapUseCase: MapUseCaseProtocol
    @ObservationIgnored
    var notificationTask: Task<Void, Never>? = nil
    
    // MARK: - Observers
    private(set) var posts: [Post] = []
    
    var testItems: [MapItem] = []
    
    var isLoading: Bool = false
    var error: Error? = nil
    
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
//    func getPosts() async {
//        isLoading = true
//        defer { isLoading = false }
//        
//        do {
//            posts = try await mapUseCase.fetchPosts(query: "")
//            let items = try await mapUseCase.fetchMapItems()
//            testItems = items
//            Log.debug("items \(items)")
//        } catch {
//            Log.error("Get Posts failed: \(error)")
//            self.error = error
//        }
//    }
//    
//    func insert(item: MapItem) async {
//        do {
//            try await mapUseCase.insert(item)
//        } catch {
//            Log.error("insert failed: \(error)")
//        }
//        
//    }
    
    func subscribeToNotifications() {
        notificationTask = Task {
            for await notification in NotificationCenter.default.notifications(named: ModelContext.didSave) {
                Log.debug("notification called \(notification.name)")
            }
        }
    }
}
