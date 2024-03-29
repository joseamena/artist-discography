//
//  LoadStatus.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import Foundation

public enum LoadStatus: Equatable {
    case loading
    case error(Error)
    case none

    public static func == (lhs: LoadStatus, rhs: LoadStatus) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.none, .none):
            return true
        case (.error(_), .error(_)):
            return true
        default:
            return false
        }
    }

    public static func != (lhs: Self, rhs: Self) -> Bool {
        !(lhs == rhs)
    }
}
