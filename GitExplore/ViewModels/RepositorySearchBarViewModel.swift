//
//  RepositorySearchViewModel.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import Foundation

class RepositorySearchViewModel {
    
    // MARK: Public properties
    
    var searchedRepositories = [GitRepositoryDetails]()
    
    var isSearchInProgress: Bool {
        return self.repositorySearchService.isSearchInProgress
    }
    
    // MARK: Private properties
    
    private var repositorySearchService: SearchService
    private var searchOperationQueue = OperationQueue()
    
    
    // MARK: Initializer
    
    init(repositorySearchService: SearchService) {
        self.repositorySearchService = repositorySearchService
    }
    
    // MARK: Public methods
    
    /// Calls repository search service to get list of repositories that fulfill the search criteria
    func searchRepositories(with keyword: String, completionHandler: @escaping BoolResponseHandler) {
        
        // Cancel existing serarch operation, if any
        if self.isSearchInProgress {
            self.searchOperationQueue.cancelAllOperations()
        }
        
        // Start search operation
        let searchOperation = BlockOperation(block: {
            self.clearSearchResults()
            self.repositorySearchService.searchRepositories(for: keyword) { searchResult, error in
                guard let result = searchResult,
                      !result.isEmpty,
                      error == nil else {
                    completionHandler(false)
                    return
                }

                self.searchedRepositories = result[0].items ?? []
                completionHandler(true)
            }
        })
        self.searchOperationQueue.addOperation(searchOperation)
    }
    
    /// Cleans last search result
    func clearSearchResults() {
        self.searchedRepositories.removeAll()
    }
}
