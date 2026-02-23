//
//  Codable+Extensions.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 19.05.2025.
//

import Foundation

// MARK: - Array -
extension Array where Element: Codable {
    func jsonString() -> String? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            
            return jsonString
        } catch {
            return nil
        }
    }
    
    func fromJsonString(_ jsonString: String) -> [Element]? {
        if let data = jsonString.data(using: .utf8) {
            do {
                return try JSONDecoder().decode([Element].self, from: data)
            } catch {
                return nil
            }
        }
        return nil
    }
}

// MARK: - Dictionary -
extension Dictionary where Key: Codable, Value: Codable {
    func jsonDictionaryString() -> String? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            
            return jsonString
        } catch {
            return nil
        }
    }
    
    static func fromDictionaryJsonString(_ jsonString: String) -> [Key: Value]? {
        if let data = jsonString.data(using: .utf8) {
            do {
                return try JSONDecoder().decode([Key: Value].self, from: data)
            } catch {
                return nil
            }
        }
        return nil
    }
}

// MARK: - Encodable -
extension Encodable {
    func jsonDictionaryString() -> String? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
        } catch {
            return nil
        }
    }
    
    func jsonString() -> String? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
        } catch {
            return nil
        }
    }
}

// MARK: - Decodable -
extension Decodable {
    static func fromDictionaryJsonString(_ jsonString: String) -> Self? {
        if let data = jsonString.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(Self.self, from: data)
            } catch {
                return nil
            }
        }
        return nil
    }
    
    static func fromJsonString(_ jsonString: String) -> Self? {
        if let data = jsonString.data(using: .utf8) {
            do {
                return try JSONDecoder().decode(Self.self, from: data)
            } catch {
                return nil
            }
        }
        return nil
    }
}

