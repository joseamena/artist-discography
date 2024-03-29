//
//  ReleaseTarget.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

struct ReleaseTarget: NetworkTarget {
    let path: String
    
    var parameters: [String : String]? = [
        "key": "TUnAIUTJDGQigRmrExsh",
        "secret": "OtcGLYlAMufmJmVsDNKVuhzfHkneclYx"
    ]
    
    var method: HTTPMethod = .get
    
    var shouldCache: Bool = false
    
    init(path: String) {
        self.path = path
    }
}
