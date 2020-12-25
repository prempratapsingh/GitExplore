//
//  GEMOCKRepositoryService.swift
//  GitExploreTests
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import Foundation
@testable import GitExplore

/// Mock Service for getting list of trending repositories
class GEMOCKRepositoryService: RepositoryService {
    
    /// Makes call to Rest service to get list of trending repositories based on given language and trending period
    func getTrendingRepositories(for language: String, period: String, responseHandler: @escaping TrendingRepositoriesResponseHandler) {
        let fileDataService = FileDataService()
        fileDataService.getData(for: LocalDataFile.respositoryList,
                                extenson: LocalDataFileExtension.json,
                                responseHandler: responseHandler)
    }
    
    /// Makes call to Rest service to get details of selected repository
    func getRepositoryDetails(for repositoryId: String, responseHandler: RepositoryDetailsResponseHandler) {
        
    }
}
