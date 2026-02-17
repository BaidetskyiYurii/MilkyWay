//
//  NavigationState.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation
import SwiftUI
import Combine

///Structure that represents the current modal presentation in the navigation flow.
///It holds the modal flow and the associated parent coordinator.
struct ModalPresentation {
    ///A placeholder coordinator used when no coordinator is provided for the modal flow.
    private final class PlaceholderCoordinator: Coordinator { }
    
    ///The modal flow that this presentation is handling.
    let modalFlow: any ModalProtocol
    
    ///The parent coordinator responsible for managing the modal flow.
    let coordinator: any Coordinator
    
    ///A closure that returns the view to be displayed for the modal.
    let destination: @MainActor ()->AnyView
    
    init(modalFlow: any ModalProtocol, destination: @escaping @MainActor @Sendable () -> AnyView) {
        self.modalFlow = modalFlow
        
        if let coordinator = modalFlow.coordinator {
            self.destination = destination
            self.coordinator = coordinator
        } else {
            let coordinator = PlaceholderCoordinator()
            self.destination = { [unowned coordinator] in AnyView(destination().withModal(coordinator)) }
            self.coordinator = coordinator
        }
    }
}

extension ModalPresentation: Equatable {
    static func == (lhs: ModalPresentation, rhs: ModalPresentation) -> Bool {
        lhs.coordinator === rhs.coordinator && lhs.modalFlow.hashValue == rhs.modalFlow.hashValue
    }
}

///Class that manages the navigation state for the coordinator.
///It stores the current navigation path, presented modal flows, and any alerts.
final class NavigationState: ObservableObject {
    ///The current navigation path, which is a list of screen identifiers in the navigation stack.
    @Published var path: [AnyHashable] = []
    
    ///The modal flow that is presented over the current navigation.
    @Published var modalPresented: ModalPresentation?
    
    ///A list of currently presented alerts.
    @Published var alerts: [Alert] = []
    
    ///A weak reference to the parent coordinator that presented the current navigation modally, if any.
    weak var presentedBy: (any Coordinator)?
    
    private var observers: [AnyCancellable] = []
    
    init() {
        $path.sink { [weak self] _ in
            self?.closeKeyboard()
        }.store(in: &observers)
        
        $modalPresented.sink { [weak self] _ in
            self?.closeKeyboard()
        }.store(in: &observers)
    }
}

// MARK: Private Helpers
private extension NavigationState {
    ///Helper method to close the keyboard when navigation or modal state changes.
    func closeKeyboard() {
        UIApplication.shared.resignFirstResponder()
    }
}

// MARK: NavigationState Models
extension NavigationState {
    struct Alert {
        let title: String
        let actions: ()->AnyView
        let message: ()->AnyView
        
        init<A: View, M: View>(title: String, actions: @escaping ()->A, message: @escaping ()->M) {
            self.title = title
            self.actions = { AnyView(actions()) }
            self.message = { AnyView(message()) }
        }
    }
}
