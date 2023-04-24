//
//  RMCharacterGender.swift
//  USG-RickAndMorty
//
//  Created by Fatih Acıroğlu on 21.04.2023.
//

import Foundation
import SwiftUI

enum RMCharacterGender: String, Codable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
    
    var color: Color {
        switch self {
        case .male:
            return Color.blue
        case .female:
            return Color.red
        case .genderless:
            return Color.gray
        case .unknown:
            return Color.gray
        }
    }
}
