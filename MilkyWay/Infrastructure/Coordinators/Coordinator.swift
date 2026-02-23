//
//  Coordinator.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 25.05.2025.
//

import Foundation
import SwiftUI
import Combine

///A class representing a weak reference for a specific Coordinator, that is passed by as an EnvironmentObject
@MainActor
final class Navigation<T>: ObservableObject {
    
    private(set) var object: (any Coordinator)?
    private var observer: AnyCancellable?
    
    init(_ object: T) where T: Coordinator {
        self.object = object
        
        ///Observer triggers changes to the SwiftUI view when the Coordinator changes
        observer = object.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    init<C: Coordinator>(_ object: C) {
        self.object = object
        
        ///Observer triggers changes to the SwiftUI view when the Coordinator changes
        observer = object.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    ///Access the Coordinator via a function call
    func callAsFunction() -> T { object as! T }
}

@MainActor
@propertyWrapper
struct CoordinatorLink<C>: DynamicProperty {
    
    @EnvironmentObject var typedCoordinator: Navigation<C>
    @EnvironmentObject var coordinator: Navigation<any Coordinator>
    
    var wrappedValue: C { coordinator() as? C ?? typedCoordinator() }
    
    init() { }
}

///A protocol representing a Coordinator, which manages the navigation flow and must be ObservableObject and Hashable
protocol Coordinator: ObservableObject, Hashable { }

///A unique key for associating a Coordinator state
private var coordinatorStateKey: UInt8 = 0

///A unique key for associating a Coordinator weak reference
private var coordinatorWeakReferenceKey: UInt8 = 0

///A unique key for associating an any Coordinator weak reference
private var coordinatorAnyWeakReferenceKey: UInt8 = 0

extension Coordinator {
    
    ///Coordinator state, encapsulates current navigation path and presented modal flow and reference to parent coordinator
    @MainActor var state: NavigationState {
        get {
            if let state = objc_getAssociatedObject(self, &coordinatorStateKey) as? NavigationState {
                return state
            } else {
                let state = NavigationState()
                objc_setAssociatedObject(self, &coordinatorStateKey, state, .OBJC_ASSOCIATION_RETAIN)
                return state
            }
        }
    }
    
    ///A weak reference to this Coordiantor, it is passed by using EnvironmentObject
    @MainActor var weakReference: Navigation<Self> {
        get {
            if let reference = objc_getAssociatedObject(self, &coordinatorWeakReferenceKey) as? Navigation<Self> {
                return reference
            } else {
                let reference = Navigation(self)
                objc_setAssociatedObject(self, &coordinatorWeakReferenceKey, reference, .OBJC_ASSOCIATION_RETAIN)
                return reference
            }
        }
    }
    
    ///A weak reference to this Coordiantor, it is passed by using EnvironmentObject so that Coordinator can be accessed by any Coordinator reference
    @MainActor var anyWeakReference: Navigation<any Coordinator> {
        get {
            if let reference = objc_getAssociatedObject(self, &coordinatorAnyWeakReferenceKey) as? Navigation<any Coordinator> {
                return reference
            } else {
                let reference = Navigation<any Coordinator>(self)
                objc_setAssociatedObject(self, &coordinatorAnyWeakReferenceKey, reference, .OBJC_ASSOCIATION_RETAIN)
                return reference
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.hashValue == rhs.hashValue }
    
    ///Dismiss modal navigation of this Coordiantor
    @MainActor func dismiss() {
        state.presentedBy?.dismissPresented()
    }
    
    ///Dismiss modal navigation presented over this Coordinator
    @MainActor func dismissPresented() {
        let modalCoordinator = state.modalPresented?.coordinator
        state.modalPresented = nil
        
        // keep it alive until animation is finished
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            _ = modalCoordinator
        }
    }
    
    ///Move to the previous screen of the current navigation stack
    @MainActor func pop() {
        state.path.removeLast()
    }
    
    ///Pops all views and returns to the root view
    @MainActor func popToRoot() {
        state.path.removeAll()
    }
}

@MainActor
extension Coordinator {
    
    ///Presents a new modal or navigation presentation based on the given ModalPresentation and resolve policy
    func present(_ presentation: ModalPresentation, resolve: PresentationResolve = .overAll) {
        if let presentedCoordinator = state.modalPresented?.coordinator {
            switch resolve {
            case .replaceCurrent:
                dismissPresented()
                
                // need await for dismiss animation complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.53) { [weak self] in
                    self?.present(presentation, resolve: resolve)
                }
            case .overAll:
                presentedCoordinator.present(presentation, resolve: resolve)
            }
        } else {
            presentation.coordinator.state.presentedBy = self
            state.modalPresented = presentation
        }
    }
}

///Extension providing utility functions for presenting alerts
@MainActor
extension Coordinator {
    
    static nonisolated var defaultAlertTitle: String {
        Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String ??
        Bundle.main.infoDictionary!["CFBundleName"] as? String ?? ""
    }
    
    private var topCoordinator: any Coordinator {
        state.modalPresented?.coordinator.topCoordinator ?? self
    }
    
    ///Presents an alert with customizable message and actions
    func alert<A: View, M: View>(_ title: String = Self.defaultAlertTitle,
                                 @ViewBuilder _ message: @escaping ()->M,
                                 @ViewBuilder actions: @escaping ()->A) {
        topCoordinator.state.alerts.append(.init(title: title, actions: actions, message: message))
    }
    
    ///Presents an alert with a default "OK" button and custom message
    func alert<M: View>(_ title: String = Self.defaultAlertTitle,
                        @ViewBuilder _ message: @escaping ()->M) {
        topCoordinator.state.alerts.append(.init(title: title,
                                                 actions: { Button("OK") {} },
                                                 message: message))
    }
    
    ///Presents an alert with a message and a default "OK" button
    func alert(_ title: String = Self.defaultAlertTitle, message: String) {
        topCoordinator.state.alerts.append(.init(title: title,
                                                 actions: { Button("OK") {} },
                                                 message: { Text(message) }))
    }
    
    ///Presents an alert with a message and customizable actions
    func alert<A: View>(_ title: String = Self.defaultAlertTitle,
                        message: String,
                        @ViewBuilder actions: @escaping ()->A) {
        topCoordinator.state.alerts.append(.init(title: title,
                                                 actions: actions,
                                                 message: { Text(message) }))
    }
}

///Typealias for a Coordinator that supports both navigation and modal presentations
typealias NavigationModalCoordinator = NavigationCoordinator & ModalCoordinator

///Extension defining custom CoordinateSpaces for navigation and modal views
extension CoordinateSpace {
    
    ///Coordinate space for a navigation controller
    static let navController = "CoordinatorSpaceNavigationController"
    
    ///Coordinate space for modal presentations
    static let modal = "CoordinatorSpaceModal"
}

