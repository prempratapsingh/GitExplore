//
//  RepositoryDetailsViewTest.swift
//  GitExploreTests
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import XCTest
@testable import GitExplore

class RepositoryDetailsViewTest: XCTestCase {

    private var repositoryDetailsViewController: RepositoryDetailsViewController?
    
    private var repositoryDetails: RepositoryDetails {
        let details = RepositoryDetails(author: "hotwired",
                                        name: "turbo-ios",
                                        languageColor: "",
                                        url: "",
                                        description: "iOS framework for making Turbo native apps",
                                        language: "",
                                        stars: "",
                                        currentPeriodStars: "",
                                        forks: "",
                                        avatar: "",
                                        builtBy: [])
        return details
    }
    
    private var authorLabelText: String {
        let authorBy = NSLocalizedString(LocalizationKeys.by_author, comment: "Label text for author")
        return "\(authorBy) \(self.repositoryDetails.author)"
    }
    
    
    
    override func setUpWithError() throws {
        self.repositoryDetailsViewController = RepositoryDetailsViewController()
    }

    override func tearDownWithError() throws {
        self.repositoryDetailsViewController = nil
    }

    func test_RepositoryDetailsViewShowsCorrectDetailsWithSetter() throws {
        let _ = self.repositoryDetailsViewController?.view
        self.repositoryDetailsViewController?.repositoryDetails = self.repositoryDetails
        
        XCTAssertTrue(self.repositoryDetailsViewController?.repositoryName == self.repositoryDetails.name,
                      "Repository details view couldn't show correct details")
        XCTAssertTrue(self.repositoryDetailsViewController?.authorName == self.authorLabelText,
                      "Repository details view couldn't show correct details")
        XCTAssertTrue(self.repositoryDetailsViewController?.descriptionText == self.repositoryDetails.description,
                      "Repository details view couldn't show correct details")
    }

    func test_RepositoryDetailsViewShowsCorrectDetailsWithConstructor() throws {
        self.repositoryDetailsViewController = RepositoryDetailsViewController(repositoryDetails: self.repositoryDetails)
        let _ = self.repositoryDetailsViewController?.view
        
        XCTAssertTrue(self.repositoryDetailsViewController?.repositoryName == self.repositoryDetails.name,
                      "Repository details view couldn't show correct details")
        
        XCTAssertTrue(self.repositoryDetailsViewController?.authorName == self.authorLabelText,
                      "Repository details view couldn't show correct details")
        XCTAssertTrue(self.repositoryDetailsViewController?.descriptionText == self.repositoryDetails.description,
                      "Repository details view couldn't show correct details")
    }
}
