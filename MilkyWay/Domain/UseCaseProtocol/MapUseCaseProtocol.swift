//
//  MapUseCaseProtocol.swift
//  MilkyWay
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import Foundation

protocol MapUseCaseProtocol {
    /// Fetches a list of posts matching the given query.
    ///
    /// - Parameter query: An optional search query string to filter posts.
    ///                    Pass `nil` to fetch all posts.
    /// - Returns: An array of `Post` objects matching the query.
    /// - Throws: An error if the fetch operation fails.
    @discardableResult
    func fetchPosts(query: String?) async throws -> [Post]
    
    func fetchMapItems() async throws -> [MapItem]
    
    func insert(_ item: MapItem) async throws
}
