//
//  String+Extensions.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 14.04.2026.
//

import Foundation

extension String {
    static func localized(_ resource: LocalizedStringResource) -> String {
        String(localized: resource)
    }
}
