//
//  Mock.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import Foundation

struct Mock {
    
    let statusCode: Int
    let error: Error?
    let data: Data?
    
    init(statusCode: Int, error: Error?, data: Data?) {
        self.statusCode = statusCode
        self.error = error
        self.data = data
    }
    
    init(statusCode: Int, error: Error?, json: String?) {
        self.statusCode = statusCode
        self.error = error
        self.data = json.flatMap { $0.data(using: .utf8) }
    }
}
