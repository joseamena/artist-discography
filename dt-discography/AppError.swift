//
//  AppError.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import Foundation

enum AppError: Error {
    case requestCreationFailed
    case httpError(Int)
    case decodingError(DecodingError?)
    case unknown
    case notConnectedToInternet
}
