//
//  String+Utf8Data.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 19.05.2025.
//

import Foundation

extension String {
    var utf8Data: Data { .init(utf8) }
    
    func toCamelCase() -> String {
        guard !self.isEmpty else { return self }
        
        let parts = self.split(separator: "_")
        let first = parts.first?.lowercased() ?? ""
        let rest = parts.dropFirst().map { $0.capitalized }
        return ([first] + rest).joined()
    }
}
