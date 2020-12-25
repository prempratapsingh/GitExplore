//
//  FileDataService.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import Foundation

/// Loads data from a give local file
/// It is primarily used for unit testing purpose to load test/mock data for view models

struct FileDataService {
    func getData<T: Codable>(for file: LocalDataFile,
                             extenson: LocalDataFileExtension,
                             responseHandler: @escaping ResponseHandler<T>) {
        
        guard let url = Bundle.main.url(forResource: file.fileName, withExtension: extenson.fileExtension) else {
            responseHandler(nil, FileDataServiceError.fileNotFound)
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonResponseData = try JSONSerialization.jsonObject(with: data, options: [])
            var resultData = [T]()
            
            /// If the server response is a list of objects
            if let listData = jsonResponseData as? [[String: Any]] {
                for item in listData {
                    let itemData = try JSONSerialization.data(withJSONObject: item, options: [])
                    let decodedItem = try decoder.decode(T.self, from: itemData)
                    resultData.append(decodedItem)
                }
                responseHandler(resultData, nil)
            }
            /// If the server response is a single object
            else {
                let decodedItem = try decoder.decode(T.self, from: data)
                resultData.append(decodedItem)
                responseHandler(resultData, nil)
            }
        } catch {
            responseHandler(nil, FileDataServiceError.dataParseError)
        }
    }
}

/**
Wrapper enumeration for errors specific to the file data service
*/
enum FileDataServiceError: String, GEError {
    case fileNotFound = "Couldn't find the given file"
    case dataParseError = "Unable to parse file data"
    
    var description: String {
        return self.rawValue
    }
}
