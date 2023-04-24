//
//  RMRequest.swift
//  USG-RickAndMorty
//
//  Created by Fatih Acıroğlu on 21.04.2023.
//

import Foundation

final class RMRequest {
    private struct Constants {
        static let baseURL = "https://rickandmortyapi.com/api"
    }

    let endpoint: RMEndpoint
    public let httpMethod = "GET"
    private let pathComponents: [String]
    private let queryParameters: [URLQueryItem]
    private let ids: [String]

    private var urlString: String {
        var myString = Constants.baseURL
        myString += "/"
        myString += endpoint.rawValue
        if !pathComponents.isEmpty {
            myString += "/"
            myString += pathComponents.joined(separator: "/")
        }

        if !queryParameters.isEmpty {
            myString += "?"
            myString += queryParameters.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        }
        if !ids.isEmpty {
            myString += "/"
            myString += ids.map { "\($0)" }.joined(separator: ",")
        }
        return myString
    }

    public var url: URL? {
        return URL(string: urlString)
    }

    public init(
        endpoint: RMEndpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = [],
        ids: [String] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
        self.ids = ids
    }
}
