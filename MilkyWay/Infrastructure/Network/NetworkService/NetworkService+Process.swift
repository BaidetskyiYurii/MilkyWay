//
//  NetworkService+Process.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 19.05.2025.
//

import Foundation

extension NetworkService {
    
    func processResponse(data: Data, response: URLResponse) {
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        let codeString = statusCode != nil ? "\(statusCode!) " : ""
        Self.debugLog(info: "Response: \n\(codeString)\(String(decoding: data, as: UTF8.self))")
    }
    
    func processError(_ error: Error) -> DataTransferError {
        switch error {
        case is DecodingError:
            return .decoding
        case let designatedError as DesignatedError:
            return .designated(designatedError)
        default:
            return .underlying(error)
        }
    }
    
    func decodeApi<T, E>(target: T.Type, failure: E.Type, from data: Data, decoder: JSONDecoder) throws -> T where T: Decodable, E: DesignatedError {
        do {
            return try decoder.decode(T.self, from: data)
        } catch let decodingError {
            let designatedError: DesignatedError
            do {
                designatedError = try decoder.decode(E.self, from: data)
            } catch {
                throw decodingError
            }
            
            throw designatedError
        }
    }
}
