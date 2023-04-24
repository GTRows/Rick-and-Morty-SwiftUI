//
//  RMServce.swift
//  USG-RickAndMorty
//
//  Created by Fatih Acıroğlu on 21.04.2023.
//

import Foundation

final class RMService {
    private init() {
    }

    enum RMServiceError: Error {
        case invalidURL
        case invalidData
        case decodingError
        case failedToCreateRequest
        case failedToGetData
    }

    static let shared = RMService()
    private let cacheManager = APICacheManager()

    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        if let cachedData = cacheManager.cachedResponse(
            for: request.endpoint,
            url: request.url
        ) {
            do {
                var result: T
                do {
                    result = try JSONDecoder().decode(type.self, from: cachedData)
                } catch {
                    result = [try JSONDecoder().decode(RMCharacter.self, from: cachedData)] as! T
                }
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            return
        }

        guard let urlRequest = self.request(from: request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            // Decode response
            do {
                var result: T
                do {
                    result = try JSONDecoder().decode(type.self, from: data)
                } catch {
                    result = [try JSONDecoder().decode(RMCharacter.self, from: data)] as! T
                }
                self?.cacheManager.setCache(
                    for: request.endpoint,
                    url: request.url,
                    data: data
                )
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}
