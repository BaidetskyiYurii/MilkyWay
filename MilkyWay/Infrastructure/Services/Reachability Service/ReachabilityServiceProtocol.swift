//
//  ReachabilityServiceProtocol.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 19.05.2025.
//

import Foundation

protocol ReachabilityServiceProtocol {
    var isConnected: Bool { get }
    
    func startMonitoring()
    func stopMonitoring()
}
