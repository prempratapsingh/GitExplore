//
//  DataService.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import Foundation

/**
 DataService calls a given backend API for loading the required data.
It supports generic concept so that it could be used to load data from any API and parsing the loaded data
to any Codable object
*/

protocol DataService: class {
    func getServiceUrl(for server: String, endpoint: String) -> String
    func getData<T: Codable>(request: NetworkRequest, responseHandler: @escaping ResponseHandler<T>)
}

extension DataService {
    
    /// Returns fully qualified Rest service URL
    func getServiceUrl(for server: String, endpoint: String) -> String {
        return "\(server)\(endpoint)"
    }
    
    /// Makes call to the Rest service, handles result and error responses by the API and delegates back the response/error
    /// for further processing
    func getData<T: Codable>(request: NetworkRequest, responseHandler: @escaping ResponseHandler<T>) {
        guard !request.url.isEmpty,
            var urlComponents = URLComponents(string: request.url) else {
            responseHandler(nil, NetworkError.internalError)
            return
        }
        
        if let parameters = request.parameters {
            var queryItems = [URLQueryItem]()
            for (key,value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: value as? String ?? ""))
            }
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            responseHandler(nil, NetworkError.internalError)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                responseHandler(nil, NetworkError.serverError)
                return
            }
            
            guard let responseData = data else {
                responseHandler(nil, NetworkError.serverError)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonResponseData = try JSONSerialization.jsonObject(with: responseData, options: [])
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
                    let decodedItem = try decoder.decode(T.self, from: responseData)
                    resultData.append(decodedItem)
                    responseHandler(resultData, nil)
                }
                
            } catch {
                responseHandler(nil, NetworkError.jsonParsingError)
            }
        }
        dataTask.resume()
    }
}


/// Rest API server URLS
struct RestAPIServer {
    static let github = "https://api.github.com"
    static let pupubird = "https://hackertab.pupubird.com"
}


/// Rest API endpoints
struct RestAPIEndpoint {
    static let repositories = "/repositories"
    static let search = "/search"
}

/// Rest API request object
struct NetworkRequest {
    let url: String
    let method: String
    let parameters: [String: Any]?
    
    init(url: String, method: String, parameters: [String: Any]? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters
    }
}

/// Rest API request methods
struct NetworkMethod {
    static let post = "post"
    static let get = "get"
    static let put = "put"
    static let delete = "delete"
}


/// Rest API errors
enum NetworkError: String, GEError {
    case internalError = "Network call failed due to some internal error"
    case serverError = "Error occurred while connecting to the server"
    case jsonParsingError = "Unable to parse JSON response"
    case nilResponseError = "Server didn't return any result"
    
    var description: String {
        return self.rawValue
    }
}
