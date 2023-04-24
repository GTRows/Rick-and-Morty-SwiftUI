//
//  RMLocation.swift
//  USG-RickAndMorty
//
//  Created by Fatih Acıroğlu on 21.04.2023.
//

import Foundation

struct RMLocation: Codable {
    let id = UUID()
    let name, type, dimension: String
    let residents: [String]
    let url, created: String
}
