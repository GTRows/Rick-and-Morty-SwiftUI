//
//  CharacterListStyleView.swift
//  USG-RickAndMorty
//
//  Created by Fatih Acıroğlu on 22.04.2023.
//

import Shimmer
import SwiftUI
import UIKit

struct CharacterCellView: View {
    var characterName: String
    var characterGender: RMCharacterGender
    var characterImage: String

    @State var image: Image = Image(systemName: "photo")
    @State var isLoaded: Bool = false
    let size = CGFloat(175)

    init(characterName: String, characterGender: RMCharacterGender, characterImage: String) {
        if characterName.isEmpty {
            self.characterName = "     "
        } else {
            self.characterName = characterName
        }
        self.characterGender = characterGender
        if characterImage.isEmpty {
            self.characterImage = "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
        } else {
            self.characterImage = characterImage
        }
    }

    var body: some View {
        VStack {
            HStack {
                if isLoaded {
                    image
                        .resizable()
                        .cornerRadius(10)
                        .frame(width: size, height: size)
                } else {
                    Rectangle()
                        .cornerRadius(10)
                        .frame(width: size, height: size)
                        .shimmering()
                }
            }.onAppear {
                let viewModel = CharacterPhotoViewModel(imageUrl: URL(string: characterImage))
                viewModel.fetchImage { result in
                    switch result {
                    case let .success(data):
                        DispatchQueue.main.async {
                            self.isLoaded = true
                            self.image = Image(uiImage: UIImage(data: data)!)
                        }
                    case .failure:
                        break
                    }
                }
            }
            Text(characterName)
                .font(.body)
                .foregroundColor(Color.black)
                .padding(.leading, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(characterGender.rawValue)
                .font(.caption)
                .foregroundColor(Color.black)
                .padding(.leading, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .frame(width: size, height: size * 1.25)
        .background(CharacterPhotoViewModel().colorForGender(characterGender))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5)
    }
}
