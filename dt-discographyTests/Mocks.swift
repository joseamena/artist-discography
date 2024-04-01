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

class MockPersistenceController: PersistenceController {
    func fetchArtist(with id: String) throws -> dt_discography.Artist {
        return Artist(id: 0, name: "name", profile: "a profile")
    }

    func saveArtist(artist _: dt_discography.Artist) {}

    func fetchReleases(for _: String) throws -> [dt_discography.Release] {
        []
    }

    func saveReleases(releases _: [dt_discography.Release], for _: String) {}

    func fetchReleaseDetails(with id: String) throws -> dt_discography.ReleaseDetails {
        return ReleaseDetails(id: 0, imageUrl: nil, imageSize: .zero, title: "", rating: nil, tracks: [])
    }

    func saveReleaseDetails(releaseDetails _: dt_discography.ReleaseDetails) {}
}

extension Release {
    static var mock: Release {
        Release(
            id: 0,
            mainRelease: nil,
            format: nil,
            title: "",
            label: nil,
            resourceUrl: "",
            year: nil,
            thumb: ""
        )
    }
}
