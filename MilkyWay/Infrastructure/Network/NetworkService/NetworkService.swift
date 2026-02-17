//
//  NetworkService.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import Combine
import Foundation

struct NetworkService<R: Route> {
    
    let baseURL: String
    
    private let session: URLSession
 
    
    init(session: URLSession = .shared, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
}

extension NetworkService: DataTransferType {
    func request(_ route: R) -> AnyPublisher<Response, DataTransferError> {
        let request = URLRequest(route: route)
        Self.debugLog(info: "Request: \(request)\n\(request.allHTTPHeaderFields ?? [:])")
        
        return session.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: processResponse)
            .map {
                Response(
                    httpResponse: $1 as? HTTPURLResponse,
                    data: $0
                )
            }
            .mapError(processError)
            .handleEvents(receiveCompletion: {
                if case let .failure(error) = $0 {
                    Self.debugLog(error: error)
                }
            })
            .eraseToAnyPublisher()
    }
    
    func request<T>(_ route: R, target: T.Type, decoder: JSONDecoder) -> AnyPublisher<T, DataTransferError> where T : Decodable {
        let request = URLRequest(route: route)
        Self.debugLog(info: "Request: \(request)\n\(request.allHTTPHeaderFields ?? [:])")
        
        return session.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: processResponse)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .mapError(processError)
            .handleEvents(receiveCompletion: {
                if case let .failure(error) = $0 {
                    Self.debugLog(error: error)
                }
            })
            .eraseToAnyPublisher()
    }
    
    func request<T, E>(_ route: R, target: T.Type, failure: E.Type, decoder: JSONDecoder) -> AnyPublisher<T, DataTransferError> where T : Decodable, E : Decodable, E : Error {
        let request = URLRequest(route: route)
        Self.debugLog(info: "Request: \(request)\n\(request.allHTTPHeaderFields ?? [:])")
        
        return session.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: processResponse)
            .tryMap { data, _ in
                return try decodeApi(target: T.self, failure: E.self, from: data, decoder: decoder)
            }
            .mapError(processError)
            .handleEvents(receiveCompletion: {
                if case let .failure(error) = $0 {
                    Self.debugLog(error: error)
                }
            })
            .eraseToAnyPublisher()
    }
}

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension NetworkService {
    func request(_ route: R) async throws -> Response {
        let request = URLRequest(route: route)
        Self.debugLog(info: "Request: \(request)\n\(request.allHTTPHeaderFields ?? [:])")
        
        do {
            let (data, response) = try await session.data(for: request)
            return Response(httpResponse: response as? HTTPURLResponse, data: data)
        } catch {
            Self.debugLog(error: error)
            throw processError(error)
        }
    }
    
    func request<T>(_ route: R, target: T.Type, decoder: JSONDecoder) async throws -> T where T : Decodable {
        let request = URLRequest(route: route)
        Self.debugLog(info: "Request: \(request)\n\(request.allHTTPHeaderFields ?? [:])")
        
        do {
            let (data, _) = try await session.data(for: request)
            return try decoder.decode(T.self, from: data)
        } catch {
            Self.debugLog(error: error)
            throw processError(error)
        }
    }
    
    func request<T, E>(_ route: R, target: T.Type, failure: E.Type, decoder: JSONDecoder) async throws -> T where T : Decodable, E : Decodable, E : Error {
        let request = URLRequest(route: route)
        Self.debugLog(info: "Request: \(request)\n\(request.allHTTPHeaderFields ?? [:])")
        
        do {
            let (data, _) = try await session.data(for: request)
            return try decodeApi(target: T.self, failure: E.self, from: data, decoder: decoder)
        } catch {
            Self.debugLog(error: error)
            throw processError(error)
        }
    }
}
