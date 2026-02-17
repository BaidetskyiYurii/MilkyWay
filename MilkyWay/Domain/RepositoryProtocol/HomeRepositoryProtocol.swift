//
//  HomeRepositoryProtocol.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 18.05.2025.
//

import Foundation

protocol HomeRepositoryProtocol {
    /// Fetches a list of posts matching the given query.
    ///
    /// - Parameter query: An optional search query string to filter posts.
    ///                    Pass `nil` to fetch all posts.
    /// - Returns: An array of `Post` objects matching the query.
    /// - Throws: An error if the fetch operation fails.
    func fetchPosts(query: String?) async throws -> [Post]
}
