//
//  TabsCoordinator.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation
import SwiftUI

final class TabsCoordinator {
    
    enum Tabs: Hashable, CaseIterable {
        case home
        case profile
        
        var title: String {
            switch self {
            case .home:
                return LS.Home.title
            case .profile:
                return LS.Profile.title
            }
        }
        
        var systemImage: String {
            switch self {
            case .home:
                return "house"
            case .profile:
                return "person"
            }
        }
    }
    
    @Published var currentTab: Tabs = .home
    
    private let tabs: [Tabs] = Tabs.allCases
    private let homeTabFlow = HomeFlowCoordinator()
    private let profileTabFlow = ProfileFlowCoordinator()
}

// MARK: - CustomCoordinator implementation
extension TabsCoordinator: CustomCoordinator {
    // root view
    func destination() -> some View {
        TabsScreen(coordinator: self)
    }
    
    @MainActor @ViewBuilder
    func view(for tab: Tabs) -> some View {
        switch tab {
        case .home:
            homeTabFlow.view(for: .home)
        case .profile:
            profileTabFlow.view(for: .profile)
        }
    }
}

// MARK: - Root View
extension TabsCoordinator {
    struct TabsScreen: View {
        @ObservedObject var coordinator: TabsCoordinator
        
        var body: some View {
            TabView(selection: $coordinator.currentTab) {
                ForEach(coordinator.tabs, id: \.self) { tab in
                    coordinator.view(for: tab)
                        .tabItem {
                            Label(tab.title, systemImage: tab.systemImage)
                        }
                        .tag(tab)
                }
            }
        }
    }
}
