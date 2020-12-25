//
//  RepositorySearchResult.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import Foundation

struct RepositorySearchResult: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [GitRepositoryDetails]?
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items = "items"
    }
}

struct GitRepositoryDetails: Codable {
    let id: UInt
    let name: String
    let description: String?
    let url: String
    let stars: UInt
    let owner: RepositoryOwner
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case url = "html_url"
        case stars = "stargazers_count"
        case owner = "owner"
    }
}

struct RepositoryOwner: Codable {
    let id: UInt
    let name: String
    let avatarUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "login"
        case avatarUrl = "avatar_url"
    }
}
