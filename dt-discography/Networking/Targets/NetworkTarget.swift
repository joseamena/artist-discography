//
//  NetworkTarget.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import Foundation

protocol NetworkTarget {
    /// The path of the target resource
    var path: String { get }
    /// The HTTP method to use when interacting with the target resource.
    var method: HTTPMethod { get }
    /// Parameters associated with the request to the target resource.
    var parameters: [String: String]? { get }
    /// Whether a requests response should be cached.
    var shouldCache: Bool { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension NetworkTarget {
    private var url: URL? {
        guard var urlComponents = URLComponents(string: path) else { return nil }
        if urlComponents.scheme == nil { return nil }
        if urlComponents.host == nil { return nil }
        if let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        return urlComponents.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("BlockchainDreamTheaterDiscographyApp/0.1", forHTTPHeaderField: "User-Agent")
        return request
    }
}
