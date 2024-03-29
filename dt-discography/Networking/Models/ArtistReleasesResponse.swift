//
//  ArtistReleasesResponse.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import Foundation

struct ArtistReleasesResponse: Decodable {
    let pagination: Pagination
    let releases: [Release]

    struct Pagination: Decodable {
        let page: Int
        let pages: Int
        let perPage: Int
        let items: Int
        let urls: Urls
    }

    struct Release: Decodable {
        let id: Int
        let status: String?
        let type: String
        let mainRelease: Int?
        let format: String?
        let label: String?
        let title: String
        let resourceUrl: String
        let role: String
        let artist: String
        let year: Int?
        let thumb: String
    }

    struct Urls: Decodable {
        let last: String?
        let next: String?
    }
}
