//
//  ArtistTarget.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import Foundation
// 260935
// artists/{artist_id}

struct ArtistTarget: NetworkTarget {

    private let artistId: String

    var path: String {
        "https://api.discogs.com/artists/\(artistId)"
    }

    var method: HTTPMethod = .get

    var parameters: [String : String]? = [
        "key": "TUnAIUTJDGQigRmrExsh",
        "secret": "OtcGLYlAMufmJmVsDNKVuhzfHkneclYx"
    ]

    var shouldCache: Bool = false

    init(artistId: String) {
        self.artistId = artistId
    }

}
