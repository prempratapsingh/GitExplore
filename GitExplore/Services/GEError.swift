//
//  GEError.swift
//  GitExplore
//
//  Created by Prem Pratap Singh on 25/12/20.
//

import Foundation

/// Protocol for appliction errors
protocol GEError: Error {
    var description: String { get }
}
