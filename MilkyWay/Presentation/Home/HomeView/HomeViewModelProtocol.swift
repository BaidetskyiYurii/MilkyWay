//
//  HomeViewModelProtocol.swift
//  SwiftUITemplate
//
//  Created by Baidetskyi Yurii on 02.06.2025.
//

import Foundation

protocol HomeViewModelProtocol: ObservableObject {
    var posts: [Post] { get }
    var isLoading: Bool { get }
    var error: Error? { get }

    func getPosts() async
}
