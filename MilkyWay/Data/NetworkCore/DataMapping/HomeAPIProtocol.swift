//
//  HomeAPIProtocol.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 19.05.2025.
//

import Foundation

protocol HomeAPIProtocol {
    func fetchPosts(query: String?) async throws -> [PostResponseDTO]
}
