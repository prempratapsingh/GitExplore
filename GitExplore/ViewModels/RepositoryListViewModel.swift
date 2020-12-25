//
//  RepositoryListViewModel.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 24/12/20.
//

import Foundation

/**
 Enum for trending period
 */
enum TrendingPeriod: Int {
    
    case daily, weekly, monthly
    
    /// Label is used to show the trending period labels in the view
    var label: String {
        switch self {
        case .daily: return NSLocalizedString(LocalizationKeys.period_daily, comment: "Label text for daily period")
        case .weekly: return NSLocalizedString(LocalizationKeys.period_weekly, comment: "Label text for weekly period")
        case .monthly: return NSLocalizedString(LocalizationKeys.period_monthly, comment: "Label text for monthly period")
        }
    }
    
    /// Id is used to pass trending duration parameter  to the API
    var id: String {
        switch self {
        case .daily: return "daily"
        case .weekly: return "weekly"
        case .monthly: return "monthly"
        }
    }
}

class RepositoryListViewModel {
    
    // MARK: Public properties
    
    var trendingRepositories = [RepositoryDetails]()
    
   
    // MARK: Private properties
    
    private var repositoryService: RepositoryService
    private let language = "swift"
    private var cachedRepositories = [TrendingPeriod : [RepositoryDetails]]()
    
    
    // MARK: Initializer
    
    init(repositoryService: RepositoryService) {
        self.repositoryService = repositoryService
    }
    
    
    // MARK: Private methods
    
    /// Calls repository service to get the list of trending repositories based on the given language abd trending period
    /// Swif is hardcoded as the language for now
    func getTrendingRepositories(for period: TrendingPeriod, responseHandler: @escaping BoolResponseHandler) {
        
        // Repositories don't need to be reloaded for monthly and weekly period
        // Check if we already have weekly and monthly trending repositories, if so
        // use the cashed repository data rather than loading them again
        if let repositories = self.cachedRepositories[period] {
            self.trendingRepositories = repositories
            responseHandler(true)
            return
        }
        
        // Load trending reposiotory, if not already loaded
        self.repositoryService.getTrendingRepositories(for: language, period: period.id) { trendingRepositories, error in
            guard let repositories = trendingRepositories, error == nil else {
                responseHandler(false)
                return
            }
            
            self.trendingRepositories = repositories
            if period == .weekly || period == .monthly {
                self.cachedRepositories[period] = repositories
            }
            
            responseHandler(true)
        }
    }
}
