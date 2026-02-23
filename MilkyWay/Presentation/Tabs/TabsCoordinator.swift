//
//  TabsCoordinator.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation
import SwiftUI

final class TabsCoordinator {
    enum Tabs: Hashable, CaseIterable {
        case map
        case routes
        case explore
        case profile
        
        var title: String {
            switch self {
            case .map:
                LS.Map.navTitle
            case .routes:
                LS.Routes.navTitle
            case .explore:
                LS.Explore.navTitle
            case .profile:
                LS.Profile.navTitle
            }
        }
        
        var systemImage: String {
            switch self {
            case .map:
                "mappin.and.ellipse"
            case .routes:
                "paperplane.fill"
            case .explore:
                "network"
            case .profile:
                "person"
            }
        }
    }
    
    @Published var currentTab: Tabs = .map
    
    private let tabs: [Tabs] = Tabs.allCases
    private let mapTabFlow = MapFlowCoordinator()
    private let routesTabFlow = RoutesFlowCoordinator()
    private let exploreTabFlow = ExploreFlowCoordinator()
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
        case .map:
            mapTabFlow.view(for: .home)
        case .routes:
            routesTabFlow.view(for: .routes)
        case .explore:
            exploreTabFlow.view(for: .explore)
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
