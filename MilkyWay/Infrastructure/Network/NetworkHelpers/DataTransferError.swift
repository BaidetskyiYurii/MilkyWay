//
//  DataTransferError.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import Foundation

typealias DesignatedError = Error & Decodable

enum DataTransferError: Error {
    case decoding
    case designated(DesignatedError)
    case underlying(Error)
}

extension DataTransferError: CustomDebugStringConvertible {
    
    var debugDescription: String {
        switch self {
        case .decoding: return "Failed to decode object"
        case let .designated(error): return error.localizedDescription
        case let .underlying(error): return error.localizedDescription
        }
    }
}

extension DataTransferError: LocalizedError {
    
    var errorDescription: String? { debugDescription }
}

