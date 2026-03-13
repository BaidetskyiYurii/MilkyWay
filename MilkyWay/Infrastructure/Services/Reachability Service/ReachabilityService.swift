//
//  ReachabilityService.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 19.05.2025.
//

import Combine
import Network
import SwiftUI

@MainActor
@Observable
final class ReachabilityService {
    private(set) var isMonitoring = false
    private(set) var pathStatus = NWPath.Status.requiresConnection
    private(set) var isConnected: Bool = true
    
    @ObservationIgnored
    private var monitor: NWPathMonitor?
    @ObservationIgnored
    private let queue = DispatchQueue(label: "NetworkStatus_Monitor")
    
    init() { startMonitoring() }
    
    deinit {
        monitor?.cancel()
        monitor = nil
    }
}

extension ReachabilityService: ReachabilityServiceProtocol {
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor = NWPathMonitor()
        monitor?.start(queue: queue)
        monitor?.pathUpdateHandler = { [weak self] path in
            // Monitor runs on a background thread so we need to publish it on the main thread
            Task { @MainActor in
                guard let self else { return }
                if self.pathStatus != path.status {
                    self.pathStatus = path.status
                    self.isConnected = path.status == .satisfied
                }
            }
        }
        isMonitoring = true
    }
    
    func stopMonitoring() {
        guard isMonitoring, let monitor else { return }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
    }
}
