//
//  ExploreFlowCoordinator.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 18.02.2026.
//

import Foundation
import SwiftUI

final class ExploreFlowCoordinator {}

// MARK: - NavigationCoordinator
extension ExploreFlowCoordinator: NavigationCoordinator {
    
    // screens available for navigation
    enum Screen: ScreenProtocol {
        case explore
    }
    
    // view for each screen
    func destination(for screen: Screen) -> some View {
        switch screen {
        case .explore: ExploreView()
        }
    }
}
