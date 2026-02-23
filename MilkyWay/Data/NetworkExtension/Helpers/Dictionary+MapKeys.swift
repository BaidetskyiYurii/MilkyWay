//
//  Dictionary+MapKeys.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 19.05.2025.
//

import Foundation

extension Dictionary {
    func mapKeys<TransformedKey: Hashable>(_ transform: (Key) -> TransformedKey) -> [TransformedKey: Value] {
        return Dictionary<TransformedKey, Value>(uniqueKeysWithValues: map { (transform($0.key), $0.value) })
    }
}
