//
//  LocalDataFile.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import Foundation

/**
Wrapper enumaration for local data file names
*/
enum LocalDataFile: String {
    
    //for testing
    case respositoryList = "daily_trending_repositories"
    
    var fileName: String {
        return self.rawValue
    }
}

/**
Wrapper enumaration for local data file extensions
*/
enum LocalDataFileExtension: String {
    
    case json = "json"
    case xml = "xml"
    
    var fileExtension: String {
        return self.rawValue
    }
}
