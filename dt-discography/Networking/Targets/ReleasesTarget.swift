//
//  ReleasesTarget.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

struct ReleasesTarget: NetworkTarget {
    private let artistId: String

    var path: String {
        "https://api.discogs.com/artists/\(artistId)/releases"
    }

    var parameters: [String: String]? = [
        "key": "TUnAIUTJDGQigRmrExsh",
        "secret": "OtcGLYlAMufmJmVsDNKVuhzfHkneclYx",
    ]

    var method: HTTPMethod = .get

    var shouldCache: Bool = true

    init(artistId: String) {
        self.artistId = artistId
    }
}
