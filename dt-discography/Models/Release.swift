//
//  Release.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

import Foundation

struct Release: Identifiable {
    let id: Int
    let format: String?
    let title: String
    let label: String?
    let resourceUrl: String
    let year: Int?
    let thumb: String
}
