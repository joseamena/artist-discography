//
//  Release.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

import Foundation

struct Release: Identifiable, Hashable {
    let id: Int
    let mainRelease: Int?
    let format: String?
    let title: String
    let label: String?
    let resourceUrl: String
    let year: Int?
    let thumb: String
}
