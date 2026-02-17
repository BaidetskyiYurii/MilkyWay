//
//  HomeRoutes.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 19.05.2025.
//

import Foundation

enum HomeRoutes {
    case fetchPosts(String, FetchPostsRequestDTO)
}

// MARK: Route implementation
extension HomeRoutes: Route {

    // Base URL
    var baseURL: URL {
        switch self {
        case .fetchPosts(let baseUrl, _):
            return URL(string: baseUrl)!
        }
    }
    
    // Path
    var path: String {
        switch self {
        case .fetchPosts:
            "posts"
        }
    }
    
    // Headers
    var httpHeaders: HttpHeaders {
        ["Content-Type": "application/json"]
    }
    
    // Method
    var httpMethod: HttpMethod {
        switch self {
        case .fetchPosts: .get
        }
    }
    
    // Parameters
    var parameters: Parameters? {
        switch self {
        case let .fetchPosts(_, parameters): return parameters.encoded()
        }
    }
    
    // Array Parameters
    var arrayParameters: ArrayParameters? {
        nil
    }
    
    // Encoding type
    var parameterEncoding: ParameterEncoding? {
        return .url
    }
}
