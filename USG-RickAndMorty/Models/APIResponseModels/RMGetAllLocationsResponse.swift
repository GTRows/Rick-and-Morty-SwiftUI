//
//  RMGetAllLocationsResponse.swift
//  USG-RickAndMorty
//
//  Created by Fatih Acıroğlu on 21.04.2023.
//

import Foundation


struct RMGetAllLocationsResponse: Codable {
    let info: RMInfo
    let results: [RMLocation]
}

struct RMInfo: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}
