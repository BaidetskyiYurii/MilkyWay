//
//  ProfileFlowCoordinator.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation
import SwiftUI

final class ProfileFlowCoordinator {}

// MARK: - NavigationCoordinator
extension ProfileFlowCoordinator: NavigationCoordinator {
    // screens available for navigation
    enum Screen: ScreenProtocol {
        case profile
    }
    
    // view for each screen
    func destination(for screen: Screen) -> some View {
        switch screen {
        case .profile: ProfileView()
        }
    }
}
