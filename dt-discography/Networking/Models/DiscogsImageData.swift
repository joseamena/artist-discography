//
//  DiscogsImageData.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

import Foundation

struct DiscogsImageData: Decodable {
    let type: String
    let uri: String
    let resourceUrl: String
    let uri150: String
    let width: Int
    let height: Int
}
