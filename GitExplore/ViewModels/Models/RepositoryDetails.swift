//
//  RepositoryDetails.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import Foundation

/// Model object for repository details

struct RepositoryDetails: Codable {
    let author: String
    let name: String
    let languageColor: String
    let url: String
    let description: String
    let language: String
    let stars: String
    let currentPeriodStars: String
    let forks: String
    let avatar: String
    let builtBy: [String]
}
