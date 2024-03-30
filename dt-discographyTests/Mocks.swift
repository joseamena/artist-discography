//
//  Mocks.swift
//  dt-discographyTests
//
//  Created by Jose A. Mena on 3/30/24.
//

import Combine
@testable import dt_discography
import Foundation

class MockNetworkClient: NetworkClient {
    var session: URLSession = .init(configuration: .default) // dummy session
    var cache: dt_discography.Cache<String, Data> = Cache<String, Data>()
    var connectivity: Bool = true
    var mockValue: Any?

    func buildRequest<T>(target _: NetworkTarget, type _: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
        guard let response = mockValue as? T else {
            return Fail(error: AppError.unknown).eraseToAnyPublisher()
        }
        return Just(response).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func buildRequest<T: Decodable>(target _: NetworkTarget, type _: T.Type, ignoreCache _: Bool) async throws -> T {
        guard let response = mockValue as? T else {
            throw AppError.unknown
        }
        return response
    }
}
