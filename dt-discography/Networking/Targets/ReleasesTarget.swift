//
//  ReleasesTarget.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

struct ReleasesTarget: NetworkTarget {
    
    private let artistId: String
    
    var parameters: [String : String]? = nil
    
    var path: String {
        "artists/\(artistId)/releases"
    }
    
    var method: HTTPMethod = .get
    
    var shouldCache: Bool = false
    
    init(artistId: String) {
        self.artistId = artistId
    }
}
