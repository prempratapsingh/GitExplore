//
//  RepositoryListTests.swift
//  GitExploreTests
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import XCTest
@testable import GitExplore

class RepositoryListViewModelTests: XCTestCase {

    private var repositoryListViewModel: RepositoryListViewModel?
    
    override func setUpWithError() throws {
        let mockRepositoryService = GEMOCKRepositoryService()
        self.repositoryListViewModel = RepositoryListViewModel(repositoryService: mockRepositoryService)
    }

    override func tearDownWithError() throws {
        self.repositoryListViewModel = nil
    }

    func test_ViewModelLoadsRepositoryListSuccessfully() throws {
        self.repositoryListViewModel?.getTrendingRepositories(for: .daily) { didLoadRepositories in
            if !didLoadRepositories {
                XCTFail()
            }
        }
        XCTAssertTrue(self.repositoryListViewModel?.trendingRepositories.count == 25, "RepositoryListViewModel failed to load data!")
    }

    func test_ViewModelParsesRepositoryListSuccessfully() throws {
        self.repositoryListViewModel?.getTrendingRepositories(for: .daily) { didLoadRepositories in
            if !didLoadRepositories {
                XCTFail()
            }
        }
        
        guard let firstRepository = self.repositoryListViewModel?.trendingRepositories.first else {
            XCTFail()
            return
        }
        XCTAssertTrue(firstRepository.name == "turbo-ios", "RepositoryListViewModel failed to parse loaded data")
        XCTAssertTrue(firstRepository.author == "hotwired", "RepositoryListViewModel failed to parse loaded data")
        XCTAssertTrue(firstRepository.stars == "78", "RepositoryListViewModel failed to parse loaded data")
    }
}
