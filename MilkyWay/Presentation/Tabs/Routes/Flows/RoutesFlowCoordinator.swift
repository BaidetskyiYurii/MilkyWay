//
//  RoutesFlowCoordinator.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 18.02.2026.
//

import Foundation
import SwiftUI

final class RoutesFlowCoordinator {}

// MARK: - NavigationCoordinator
extension RoutesFlowCoordinator: NavigationCoordinator {
    
    // screens available for navigation
    enum Screen: ScreenProtocol {
        case routes
    }
    
    // view for each screen
    func destination(for screen: Screen) -> some View {
        switch screen {
        case .routes: RoutesView()
        }
    }
}
