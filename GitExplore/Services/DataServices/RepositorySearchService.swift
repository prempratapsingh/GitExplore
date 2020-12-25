//
//  RepositorySearchService.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import Foundation

/// Typealias for search API response handler
typealias SearchRepositoriesResponseHandler = ([RepositorySearchResult]?, GEError?) -> Void


/// Protocol for the search service
protocol SearchService: DataService {
    var isSearchInProgress: Bool { get }
    func searchRepositories(for keyword: String, responseHandler: @escaping SearchRepositoriesResponseHandler)
}

/// Search repository service class
class RepositorySearchService: SearchService {
    
    var isSearchInProgress: Bool {
        return self.searchTask != nil
    }
    
    private var searchTask: URLSessionDataTask?
    
    func searchRepositories(for keyword: String, responseHandler: @escaping SearchRepositoriesResponseHandler) {
        let url = self.getServiceUrl(for: RestAPIServer.github, endpoint: RestAPIEndpoint.search)
        let parameters: [String: Any] = [
            "q": keyword,
            "per_page": 20
        ]
        let networkRequest = NetworkRequest(url: url, method: NetworkMethod.get, parameters: parameters)
        
        // Cancel existing search task, if any
        if let task = self.searchTask, task.state == .running {
            task.cancel()
            self.searchTask = nil
        }
        
        // Get a new search taskf
        self.searchTask = getData(request: networkRequest, responseHandler: responseHandler)
    }
}
