//
//  PostResponseDTO.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import Foundation

struct PostResponseDTO: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    private enum CodingKeys: String, CodingKey {
        case userId
        case id
        case title
        case body
    }
    
    init(
        userId: Int,
        id: Int,
        title: String,
        body: String
    ) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
}

extension PostResponseDTO {
    func toDomain() -> Post {
        return Post(userId: userId,
                    id: id,
                    title: title,
                    body: body)
    }
}
