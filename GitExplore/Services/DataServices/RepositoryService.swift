//
//  RepositoryService.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import Foundation

/// Type alias for trending repository API response handler
typealias TrendingRepositoriesResponseHandler = ([RepositoryDetails]?, GEError?) -> Void

/// Type alias for repository details API response handler
typealias RepositoryDetailsResponseHandler = ([RepositoryDetails]?, GEError?) -> Void


/// Protocol for RepositoryService
protocol RepositoryService: DataService {
    func getTrendingRepositories(for language: String, period: String, responseHandler: @escaping TrendingRepositoriesResponseHandler)
    func getRepositoryDetails(for repositoryId: String, responseHandler: RepositoryDetailsResponseHandler)
}

/// Service for getting list of trending repositories
class GERepositoryService: RepositoryService {
    
    /// Makes call to Rest service to get list of trending repositories based on given language and trending period
    func getTrendingRepositories(for language: String, period: String, responseHandler: @escaping TrendingRepositoriesResponseHandler) {
        let url = self.getServiceUrl(for: RestAPIServer.pupubird, endpoint: RestAPIEndpoint.repositories)
        let parameters = [
            "language": language,
            "since": period
        ]
        let networkRequest = NetworkRequest(url: url, method: NetworkMethod.get, parameters: parameters)
        self.getData(request: networkRequest, responseHandler: responseHandler)
    }
    
    /// Makes call to Rest service to get details of selected repository
    func getRepositoryDetails(for repositoryId: String, responseHandler: RepositoryDetailsResponseHandler) {
        
    }
}
