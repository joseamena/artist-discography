//
//  ReleaseResponse.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

struct ReleaseResponse: Decodable {
    let id: Int
    let title: String
    let year: Int
    let tracklist: [Track]
    let images: [DiscogsImageData]
    let formats: [Format]?
    let genres: [String]
    let styles: [String]
    let community: Community?

    struct Track: Decodable {
        let position: String
        let title: String
        let duration: String
    }

    struct Format: Decodable {
        let name: String
        let qty: String
    }

    struct Community: Decodable {
        let have: Int
        let want: Int
        let rating: Rating

        struct Rating: Decodable {
            let count: Int
            let average: Double
        }
    }
}
