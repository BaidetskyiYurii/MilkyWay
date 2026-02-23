//
//  Response.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import Foundation

struct Response {
    
    let httpResponse: HTTPURLResponse?
    let data: Data?
    
    init(httpResponse: HTTPURLResponse?, data: Data?) {
        self.httpResponse = httpResponse
        self.data = data
    }
}
