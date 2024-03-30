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

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .requestCreationFailed:
            "Request Error"
        case .httpError:
            "Network Error"
        case .decodingError:
            "Decoding Error"
        case .unknown:
            "Unknown Error"
        case .notConnectedToInternet:
            "Offline"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .requestCreationFailed:
            "Request creation failed"
        case let .httpError(errorCode):
            "HTTP error code: \(errorCode)"
        case let .decodingError(decodingError):
            decodingError.debugDescription
        case .unknown:
            "An unknown error has ocurred"
        case .notConnectedToInternet:
            "Check your internet connection"
        }
    }
}
