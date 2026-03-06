//
//  HomeDetailsFlowCoordinator.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation
import SwiftUI

final class HomeDetailsFlowCoordinator {}

// MARK: - NavigationCoordinator
extension HomeDetailsFlowCoordinator: NavigationCoordinator {
    
    // screens available for navigation
    enum Screen: ScreenProtocol {
        case homeDetails
    }
    
    // view for each screen
    func destination(for screen: Screen) -> some View {
        switch screen {
        case .homeDetails: Text("post.title")
        }
    }
}
