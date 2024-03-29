//
//  ArtistResponse.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import Foundation

struct ArtistResponse: Decodable {
    let name: String
    let id: Int
    let resourceUrl: String
    let uri: String
    let releasesUrl: String
    let images: [DiscogsImageData]
    let profile: String
    let urls: [String]?
    let members: [Member]?

    struct Member: Decodable {
        let id: Int
        let name: String
        let active: Bool
    }
}
