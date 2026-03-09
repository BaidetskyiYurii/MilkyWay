//
//  LinearGradient+Extensions.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 09.03.2026.
//

import SwiftUI

extension LinearGradient {
    static let mapBottom: LinearGradient = .init(
        stops: [
            .init(color: .mwBackground, location: 0),
            .init(color: .mwBackground, location: 0.35),
            .init(color: .mwBackground.opacity(0.1), location: 0.9),
            .init(color: .mwBackground.opacity(0.05), location: 0.95),
            .init(color: .mwBackground.opacity(0), location: 1)
        ],
        startPoint: .bottom,
        endPoint: .top
    )
}
