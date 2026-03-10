//
//  MilkyWayApp.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import SwiftUI
import SwiftData
import FactoryKit

@main
struct MilkyWayApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Injected(\.modelContainer) private var sharedModelContainer
    
    @InjectedObservable(\.locationService) private var locationService
    
    @StateObject var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            appCoordinator.rootView
                .environment(locationService)
        }
        .modelContainer(sharedModelContainer)
    }
}
