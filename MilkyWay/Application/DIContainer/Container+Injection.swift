//
//  Container+Injection.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 23.05.2025.
//

import Foundation
import FactoryKit

// MARK: - Services -
extension Container {
    // Configuration
    var configuration: Factory<Configuration> {
        self { Configuration() }
            .scope(.cached)
    }
    
    
    // Reachability
    var reachability: Factory<ReachabilityProtocol> {
        self { Reachability() }
            .scope(.cached)
    }
}

// MARK: - Network -
extension Container {
    
    // Home API
    var homeAPI: Factory<HomeAPIProtocol> {
        self { NetworkService<HomeRoutes>(baseURL: self.configuration.callAsFunction().apiURL) }
            .scope(.cached)
    }
}

// MARK: - Repositories -
extension Container {
    // Home Repository
    var homeRepository: Factory<HomeRepositoryProtocol> {
        self { HomeRepository(api: self.homeAPI.callAsFunction(),
                              reachability: self.reachability.callAsFunction()) }
        .scope(.cached)
    }
}

// MARK: - Use Cases -
extension Container {
    
    // Home Use Case
    var homeUseCase: Factory<HomeUseCaseProtocol> {
        self { HomeUseCase(repository: self.homeRepository.callAsFunction()) }
            .scope(.cached)
    }
}

// MARK: - Mock Use Cases -
extension Container {
    // Mock Home Use Case
    var mockHomeUseCase: Factory<HomeUseCaseProtocol> {
        self { MockHomeUseCase(repository: self.homeRepository.callAsFunction()) }
            .scope(.cached)
    }
}
