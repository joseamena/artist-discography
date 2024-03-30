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
    var connectivity: Bool { get }
    func buildRequest<T: Decodable>(target: NetworkTarget, type _: T.Type) -> AnyPublisher<T, Error>
    func buildRequest<T: Decodable>(target: NetworkTarget, type _: T.Type) async throws -> T
}

// MARK: - Protocol Default Implementations -

extension NetworkClient {
    func buildRequest<T: Decodable>(target: NetworkTarget, type _: T.Type) -> AnyPublisher<T, Error> {
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

    func buildRequest<T: Decodable>(target: NetworkTarget, type _: T.Type) async throws -> T {
        print("Connected:", connectivity)
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
            return try decode(from: data)
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
    private let monitor = NWPathMonitor()
    private let connectivitySubject = CurrentValueSubject<Bool, Never>(false)
    private var cancellables = Set<AnyCancellable>()

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

        connectivitySubject.sink(receiveValue: {
            print("received:", $0)
        })
        .store(in: &cancellables)
    }
}
