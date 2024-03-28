//
//  NetworkClient.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import Foundation
import Combine

protocol NetworkClient {
    var session: URLSession { get }
    func buildRequest<T: Decodable>(target: NetworkTarget, type: T.Type) -> AnyPublisher<T, Error>
}

extension NetworkClient {
    func buildRequest<T: Decodable>(target: NetworkTarget, type: T.Type) -> AnyPublisher<T, Error> {
        guard let request = target.urlRequest else {
            return Fail(error: AppError.requestCreationFailed)
                .eraseToAnyPublisher()
        }
        
       return session.dataTaskPublisher(for: request).tryMap { data, response -> T in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.unknown
            }
            guard 200..<300 ~= httpResponse.statusCode else {
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
    
    func buildRequest<T: Decodable>(target: NetworkTarget, type: T.Type) async throws -> T{
        guard let request = target.urlRequest else {
            throw AppError.requestCreationFailed
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.unknown
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            throw AppError.httpError(httpResponse.statusCode)
        }
        do {
            return try decode(from: data)
        } catch {
            throw AppError.decodingError(error as? DecodingError)
        }
    }
}

extension NetworkClient {
    func decode<T: Decodable>(
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

class DTDiscographyClient: NetworkClient {
    let session: URLSession
    var cancellables = Set<AnyCancellable>()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}
