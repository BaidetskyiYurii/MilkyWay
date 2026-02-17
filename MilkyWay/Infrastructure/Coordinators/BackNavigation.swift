//
//  BackNavigation.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 17.02.2026.
//

import SwiftUI

private struct BackNavigationDetector: ViewModifier {
    @CoordinatorLink private var coordinator: any NavigationCoordinator
    @State private var initialPathCount: Int?
    
    private let didNavigateBack: ()->()
    
    init(didNavigateBack: @escaping ()->()) {
        self.didNavigateBack = didNavigateBack
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if initialPathCount == nil {
                initialPathCount = coordinator.state.path.count
            }
        }.onReceive(coordinator.state.$path) {
            if let initialPathCount, $0.count < initialPathCount {
                didNavigateBack()
            }
        }
    }
}

extension View {
    func onNavigateBack(_ closure: @escaping ()->()) -> some View {
        modifier(BackNavigationDetector(didNavigateBack: closure))
    }
}

