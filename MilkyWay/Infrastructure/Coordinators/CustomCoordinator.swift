//
//  CustomCoordinator.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation
import SwiftUI

protocol CustomCoordinator: Coordinator {
    associatedtype DestinationView: View
    
    @MainActor
    func destination() -> DestinationView
}

@MainActor
extension CustomCoordinator {
    var rootView: some View { destination().withModal(self) }
}
