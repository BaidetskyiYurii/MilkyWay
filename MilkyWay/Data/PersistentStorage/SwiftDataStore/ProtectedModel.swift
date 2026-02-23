//
//  ProtectedModel.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 19.02.2026.
//

import SwiftData
import Foundation

protocol ProtectedModel: Sendable, Identifiable {
    associatedtype Model: PersistentModel
    var persistentModelID: PersistentIdentifier? { get }
    
    init(from item: Model)
}

