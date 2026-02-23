//
//  Parameterable.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 19.05.2025.
//

import Foundation

protocol Parameterable: Encodable {}

extension Parameterable {
    func encoded(encoder: JSONEncoder = .apiEncoder) -> [String: String] {
        guard let dictionary = try? JSONSerialization.jsonObject(
            with: encoder.encode(self), options: .allowFragments
        ) as? [String: Any] else {
            return [:]
        }
        
        return dictionary.mapValues { "\($0)" }
    }
    
    func encodedCamelCase(encoder: JSONEncoder = .apiEncoder) -> [String: Any] {
        guard let dictionary = try? JSONSerialization.jsonObject(
            with: encoder.encode(self), options: .allowFragments
        ) as? [String: Any] else {
            return [:]
        }
        
        let camelCasedDictionary = dictionary.mapKeys { key in
            return key.toCamelCase()
        }
        
        return camelCasedDictionary.mapValues { value in
            if let stringValue = value as? String,
               let parsedValues = parseKeyValuePairs(from: stringValue) {
                return parsedValues
            }
            return value
        }
    }
}

private extension Parameterable {
    func parseKeyValuePairs(from stringValue: String) -> [String: Any]? {
        let pattern = #"\{\s*([\w\s]+)\s*=\s*([-+]?\d*\.?\d+|\\"[^\\]*\\"|\\"[^\\]*\\")\s*;\s*\}"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        
        guard let regex = regex else { return nil }
        
        var keyValuePair: [String: Any] = [:]
        
        regex.enumerateMatches(in: stringValue, options: [], range: NSRange(location: 0, length: stringValue.utf16.count)) { match, _, _ in
            guard let match = match else { return }
            
            let keyRange = Range(match.range(at: 1), in: stringValue)
            let valueRange = Range(match.range(at: 2), in: stringValue)
            
            if let key = keyRange.flatMap({ stringValue[$0].trimmingCharacters(in: .whitespaces) }),
               let valueString = valueRange.flatMap({ stringValue[$0] }) {
                if let value = Double(valueString) {
                    keyValuePair[key] = value
                } else {
                    keyValuePair[key] = valueString
                }
            }
        }
        
        return keyValuePair.isEmpty ? nil : keyValuePair
    }
}

