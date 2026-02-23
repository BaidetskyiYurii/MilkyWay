//
//  MapFlowCoordinator.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation
import SwiftUI
import FactoryKit

final class MapFlowCoordinator {}

// MARK: - NavigationCoordinator
extension MapFlowCoordinator: NavigationCoordinator {
    
    // screens available for navigation
    enum Screen: ScreenProtocol {
        case home
        case homeDetails(Post)
    }
    
    // view for each screen
    func destination(for screen: Screen) -> some View {
        switch screen {
        case .home: MapView()
        case .homeDetails(let post): HomeDetailsView(post: post)
        }
    }
}

// MARK: - ModalCoordinator
extension MapFlowCoordinator: ModalCoordinator {
    enum Modal: ModalProtocol {
        case modalDetails(HomeDetailsFlowCoordinator = .init())
        
        var style: ModalStyle {
            switch self {
            case .modalDetails: .sheet
            }
        }
    }
    
    // view for each modal screen
    func destination(for modal: Modal) -> some View {
        switch modal {
        case .modalDetails(let coordinator):
            coordinator.view(for: .homeDetails(.dummy))
                .presentationDetents([.medium])
        }
    }
}
