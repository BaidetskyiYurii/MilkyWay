//
//  URLRequest+Extensions.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import Foundation

extension URLRequest {
    
    init(route: Route) {
        var url = route.url
        var headers = route.httpHeaders
        var body: Data?
        
        if let parameters = route.parameters,
           let parameterEncoding = route.parameterEncoding {
            switch parameterEncoding {
            case .json:
                if let data = try? JSONSerialization.data(withJSONObject: parameters) {
                    headers["Content-Type"] = "application/json"
                    body = data
                }
            case .url:
                var urlComponents = URLComponents(url: route.url, resolvingAgainstBaseURL: false)
                let queryItems = urlComponents?.queryItems ?? [URLQueryItem]()
                let encodedQueryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
                urlComponents?.queryItems = queryItems + encodedQueryItems
                url = urlComponents?.url ?? url
            }
        }
        
        if let arrayParameters = route.arrayParameters,
           let parameterEncoding = route.parameterEncoding {
            switch parameterEncoding {
            case .json:
                if let data = try? JSONSerialization.data(withJSONObject: arrayParameters) {
                    headers["Content-Type"] = "application/json"
                    body = data
                }
            case .url:
                var urlComponents = URLComponents(url: route.url, resolvingAgainstBaseURL: false)
                var queryItems = urlComponents?.queryItems ?? [URLQueryItem]()
                
                for dict in arrayParameters {
                    for (key, value) in dict {
                        // Convert the value to a string if possible, otherwise use an empty string or some default value
                        let valueString = "\(value)"
                        queryItems.append(URLQueryItem(name: key, value: valueString))
                    }
                }
                
                urlComponents?.queryItems = queryItems
                url = urlComponents?.url ?? url
            }
        }
        
        self.init(url: url)
        httpMethod = route.httpMethod.rawValue
        httpBody = body
        headers.forEach { setValue($0.value, forHTTPHeaderField: $0.key) }
    }
}
