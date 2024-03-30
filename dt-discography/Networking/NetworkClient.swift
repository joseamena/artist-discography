//
//  NetworkClient.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import Combine
import Foundation
import Network

// MARK: - Protocol -

protocol NetworkClient {
    var session: URLSession { get }
    var cache: Cache<String, Data> { get }
    var connectivity: Bool { get }
    func buildRequest<T: Decodable>(target: NetworkTarget, type _: T.Type, ignoreCache: Bool) -> AnyPublisher<T, Error>
    func buildRequest<T: Decodable>(target: NetworkTarget, type _: T.Type, ignoreCache: Bool) async throws -> T
}

// MARK: - Protocol Default Implementations -

extension NetworkClient {
    // MARK: - NetworkClient Combine Implementation -

    // At the moment not being used, the project started using combine, but decided to go in another direction
    // Left this here in case I need to re-consider and go back
    func buildRequest<T: Decodable>(target: NetworkTarget, type _: T.Type, ignoreCache _: Bool = true) -> AnyPublisher<T, Error> {
        guard connectivity else {
            return Fail(error: AppError.notConnectedToInternet)
                .eraseToAnyPublisher()
        }

        guard let request = target.urlRequest else {
            return Fail(error: AppError.requestCreationFailed)
                .eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: request).tryMap { data, response -> T in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.unknown
            }
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                throw AppError.httpError(httpResponse.statusCode)
            }
            do {
                return try decode(from: data)
            } catch {
                throw AppError.decodingError(error as? DecodingError)
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: - NetworkClient Async Await Implementation -

    func buildRequest<T: Decodable>(target: NetworkTarget, type _: T.Type, ignoreCache: Bool = true) async throws -> T {
        // Check if there is cached data
        if !ignoreCache, let cachedData = cache.value(forKey: target.cacheKey) {
            return try decode(from: cachedData)
        }

        guard connectivity else {
            throw AppError.notConnectedToInternet
        }
        guard let request = target.urlRequest else {
            throw AppError.requestCreationFailed
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.unknown
        }
        guard 200 ..< 300 ~= httpResponse.statusCode else {
            throw AppError.httpError(httpResponse.statusCode)
        }
        do {
            let decoded: T = try decode(from: data)
            if target.shouldCache {
                cache.insert(data, forKey: target.cacheKey)
            }
            return decoded
        } catch {
            throw AppError.decodingError(error as? DecodingError)
        }
    }
}

// MARK: - Private Extensions -

extension NetworkClient {
    private func decode<T: Decodable>(
        type _: T.Type = T.self,
        from data: Data
    ) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw error
        }
    }
}

// MARK: - Concrete Implementation -

class DTDiscographyClient: NetworkClient {
    let session: URLSession = .shared
    let cache = Cache<String, Data>()
    private let monitor = NWPathMonitor()
    private let connectivitySubject = CurrentValueSubject<Bool, Never>(false)

    static let shared = DTDiscographyClient()

    private init() {
        setupNetworkMonitor()
    }

    var connectivity: Bool {
        connectivitySubject.value
    }

    private func setupNetworkMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.connectivitySubject.send(path.status == .satisfied)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
