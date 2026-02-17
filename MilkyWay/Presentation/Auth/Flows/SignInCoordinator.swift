//
//  SignInCoordinator.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 24.06.2025.
//

import Foundation
import SwiftUI

final class SignInCoordinator {}

// MARK: - NavigationCoordinator
extension SignInCoordinator: NavigationCoordinator {
    
    // screens available for navigation
    enum Screen: ScreenProtocol {
        case signIn
    }
    
    // view for each screen
    func destination(for screen: Screen) -> some View {
        switch screen {
        case .signIn: SignInView()
        }
    }
}
