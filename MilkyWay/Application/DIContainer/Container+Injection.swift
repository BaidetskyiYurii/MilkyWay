//
//  Container+Injection.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 23.05.2025.
//

import Foundation
import FactoryKit
import SwiftData

// MARK: - Services -
extension Container {
    // Configuration
    var configuration: Factory<Configuration> {
        self { Configuration() }
            .scope(.cached)
    }
    
    
    // Reachability
    var reachabilityService: Factory<ReachabilityServiceProtocol> {
        self { ReachabilityService() }
            .scope(.cached)
    }
    
    var locationService: Factory<LocationService> {
        self { @MainActor in LocationService() }
            .scope(.singleton)
    }
}

// MARK: - Network -
extension Container {
    
    // Home API
    var homeAPI: Factory<MapAPIProtocol> {
        self { NetworkService<HomeRoutes>(baseURL: self.configuration().apiURL) }
            .scope(.cached)
    }
}

// MARK: - Storage -
extension Container {
    
    // Model Container
    var modelContainer: Factory<ModelContainer> {
        self {
            do {
                let container = try ModelContainer(for: MapRouteDTO.self,
                                                   migrationPlan: MapRouteDTOMigrationPlan.self)
                
                for config in container.configurations {
                    Log.debug("📦 SwiftData model stored at: \(config.url.path)")
                }
                
                return container
            } catch {
                fatalError("❌ Failed to create ModelContainer: \(error)")
            }
        }
        .scope(.singleton)
    }
    
    // Map Storage
    var mapStorage: Factory<MapStorageProtocol> {
        self {
            MapStorage(modelContainer: self.modelContainer())
        }
        .scope(.cached)
    }
}

// MARK: - Repositories -
extension Container {
    // Map Repository
    var mapRepository: Factory<MapRepositoryProtocol> {
        self { MapRepository(api: self.homeAPI(),
                              reachability: self.reachabilityService(),
                              storage: self.mapStorage()) }
        .scope(.cached)
    }
}

// MARK: - Use Cases -
extension Container {
    
    // Map Use Case
    var mapUseCase: Factory<MapUseCaseProtocol> {
        self { MapUseCase(repository: self.mapRepository()) }
            .scope(.cached)
    }
}

// MARK: - ViewModels -
extension Container {
    
    // MapViewModel
    var mapViewModel: Factory<MapViewModel> {
        self { @MainActor in MapViewModel(mapUseCase: self.mapUseCase()) }
    }
    
    // RoutesViewModel
    var routesViewModel: Factory<RoutesViewModel> {
        self { @MainActor in RoutesViewModel(mapUseCase: self.mapUseCase()) }
    }
}

// MARK: - Mock Use Cases -
//extension Container {
//    // Mock Home Use Case
//    var mockMapUseCase: Factory<MapUseCaseProtocol> {
//        self { MockMapUseCase(repository: self.mapRepository()) }
//            .scope(.cached)
//    }
//}
