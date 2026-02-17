//
//  NetworkService+Log.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import Foundation

extension NetworkService {
    
    static func debugLog(info: String) {
        #if DEBUG
        print("[NetworkService][INFO] \(info)")
        #endif
    }
    
    static func debugLog(error: Error) {
        #if DEBUG
        print("[NetworkService][ERROR] \(error.localizedDescription)")
        
        guard let decodingError = error as? DecodingError else {
            print("[NetworkService][ERROR] UserInfo: \((error as NSError).userInfo)")
            return
        }
        
        switch decodingError {
        case .typeMismatch(let type, let context):
            print("[NetworkService][DecodingError] Type mismatch: \(type). Context: \(context)")
        case .valueNotFound(let type, let context):
            print("[NetworkService][DecodingError] Value not found: \(type). Context: \(context)")
        case .keyNotFound(let key, let context):
            print("[NetworkService][DecodingError] Key not found: \(key). Context: \(context)")
        case .dataCorrupted(let context):
            print("[NetworkService][DecodingError] Data corrupted. Context: \(context)")
        @unknown default:
            print("[NetworkService][DecodingError] Unknown decoding error: \(decodingError)")
        }
        #endif
    }
}
