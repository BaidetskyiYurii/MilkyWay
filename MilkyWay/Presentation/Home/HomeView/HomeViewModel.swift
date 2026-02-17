//
//  HomeViewModel.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation

@Observable
@MainActor
final class HomeViewModel {
    // MARK: - Properties
    @ObservationIgnored
    private let homeUseCase: HomeUseCaseProtocol
    
    // MARK: - Observers
    private(set) var posts: [Post] = []
    var isLoading: Bool = false
    var error: Error? = nil
    
    // MARK: - Init methods
    init(homeUseCase: HomeUseCaseProtocol) {
        Log.debug("HomeViewModel init")
        self.homeUseCase = homeUseCase
    }
    
    deinit {
        Log.debug("HomeViewModel deinit")
    }
}

// MARK: - Public Methods
extension HomeViewModel {
    func getPosts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            posts = try await homeUseCase.fetchPosts(query: "")
        } catch {
            Log.error("Get Posts failed: \(error)")
            self.error = error
        }
    }
}
