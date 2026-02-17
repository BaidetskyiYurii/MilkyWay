//
//  Route.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import Foundation

protocol Route {
    
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var httpHeaders: HttpHeaders { get }
    var parameters: Parameters? { get }
    var arrayParameters: ArrayParameters? { get }
    var parameterEncoding: ParameterEncoding? { get }
}

extension Route {
    
    var url: URL {
        guard !path.isEmpty else {
            return baseURL
        }
        
        return baseURL.appendingPathComponent(path)
    }
}

