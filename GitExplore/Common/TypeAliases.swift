//
//  TypeAliases.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import Foundation

/// Typealias for DataService response
typealias ResponseHandler<T: Codable> = ([T]?, GEError?) -> Void

/// Typealias for checking completion state of the DataService calls
typealias BoolResponseHandler = (Bool) -> Void
