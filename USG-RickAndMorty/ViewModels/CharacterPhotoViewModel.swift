//
//  CharacterPhotoViewModel.swift
//  USG-RickAndMorty
//
//  Created by Fatih Acıroğlu on 23.04.2023.
//

import Foundation
import SwiftUI


final class CharacterPhotoViewModel {
    private let imageUrl: URL?

    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
    
    init(){
        self.imageUrl = URL(string: "")
    }

    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
    
    public func colorForGender(_ gender: RMCharacterGender) -> Color {
        switch gender {
        case .male:
            return Color.blue
        case .female:
            return Color.red
        case .genderless:
            return Color.gray
        case .unknown:
            return Color.white
        }
    }
}
