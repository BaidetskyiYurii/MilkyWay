//
//  HomeViewModel.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation

final class HomeViewModel: HomeViewModelProtocol {
    // MARK: - Properties
    private let homeUseCase: HomeUseCaseProtocol
    
    // MARK: - Observers
    @Published private(set) var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil
    
    // MARK: - Init methods
    init(homeUseCase: HomeUseCaseProtocol) {
        self.homeUseCase = homeUseCase
    }
}

// MARK: - Public Methods
extension HomeViewModel {
    @MainActor
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
