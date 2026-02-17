//
//  ReachabilityProtocol.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 19.05.2025.
//

import Foundation

protocol ReachabilityProtocol {
    var isConnected: Bool { get }
    
    func startMonitoring()
    func stopMonitoring()
}
