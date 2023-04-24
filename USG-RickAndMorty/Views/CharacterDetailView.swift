//
//  CharacterDetailView.swift
//  USG-RickAndMorty
//
//  Created by Fatih Acıroğlu on 22.04.2023.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: RMCharacter
    @State var image: Image = Image(systemName: "photo")
    @State var isLoaded: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .center) {
                    HStack {
                        if isLoaded {
                            image
                                .resizable()
                                .cornerRadius(20)
                                .frame(width: 275, height: 275)
                                .padding(3)
                                .background(CharacterPhotoViewModel().colorForGender(character.gender))
                                .cornerRadius(20)
                                .padding(.horizontal, 50)
                                .padding(.vertical, 20)
                                
                        } else {
                            Rectangle()
                                .frame(width: 275, height: 275)
                                .padding(.horizontal, 50)
                                .padding(.vertical, 20)
                                .shimmering()
                        }
                    }
                    .onAppear {
                        var viewModel = CharacterPhotoViewModel(imageUrl: URL(string: character.image))
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
                    VStack(alignment: .leading) {
                        CharacterDetailTextView(title: "Status: ", data: character.status.rawValue, verticalPadding: 0)
                        CharacterDetailTextView(title: "Specy: ", data: character.species)
                        CharacterDetailTextView(title: "Gender: ", data: character.gender.rawValue)
                        CharacterDetailTextView(title: "Origin: ", data: character.origin.name)
                        CharacterDetailTextView(title: "Location: ", data: character.location.name)
                        CharacterDetailTextView(title: "Episodes: ", data: character.episode.joined(separator: ", "))
                        CharacterDetailTextView(title: "Created at (in API): ", data: character.created)
                    }
                    .padding(.bottom, 15)
                }
            }
            .background(Color("Background"))
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
