//
//  AppCoordinator.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 24.06.2025.
//

import Foundation
import SwiftUI

final class AppCoordinator {
    enum AppFlow: Hashable, CaseIterable {
        case signIn
        case tabs
    }
    
    @Published var currentFlow: AppFlow = AppData.isSignedIn ? .tabs : .signIn
    
    private let signInFlow = SignInCoordinator()
    private let tabs = TabsCoordinator()
}

// MARK: - Public methods
extension AppCoordinator {
    func handleSignIn() {
        AppData.isSignedIn = true
        currentFlow = .tabs
    }
    
    func handleLogOut() {
        AppData.isSignedIn = false
        currentFlow = .signIn
    }
}

// MARK: - CustomCoordinator
extension AppCoordinator: CustomCoordinator {
    // root view
    func destination() -> some View {
        RootView(coordinator: self)
    }
    
    @MainActor @ViewBuilder
    func view(for flow: AppFlow) -> some View {
        switch flow {
        case .signIn:
            signInFlow.view(for: .signIn)
        case .tabs:
            tabs.rootView
        }
    }
}

// MARK: - Root View
extension AppCoordinator {
    struct RootView: View {
        @ObservedObject var coordinator: AppCoordinator
        
        var body: some View {
            coordinator.view(for: coordinator.currentFlow)
        }
    }
}
