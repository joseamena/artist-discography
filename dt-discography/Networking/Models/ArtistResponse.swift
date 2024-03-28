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
    let images: [Image]
    let profile: String
    let urls: [String]?
    let members: [Member]?

    struct Image: Decodable {
        let type: String
        let uri: String
        let resourceUrl: String
        let uri150: String
        let width: Int
        let height: Int
    }

    struct Member: Decodable {
        let id: Int
        let name: String
        let active: Bool
    }
}
