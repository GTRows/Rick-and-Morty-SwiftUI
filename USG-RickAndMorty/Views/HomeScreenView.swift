//
//  HomeScreenView.swift
//  USG-RickAndMorty
//
//  Created by Fatih Acıroğlu on 22.04.2023.
//

import Foundation
import Shimmer
import SwiftUI

struct HomeScreenView: View {
    @ObservedObject var viewModel = HomeScreenViewModel()
    @State var selectedLocationIndex: Int = 0
    @State var screenWith = UIScreen.main.bounds.width
    var body: some View {
        NavigationView {
            VStack {
//                Locations view
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 10) {
                        if !viewModel.isLoading {
                            ForEach(viewModel.locations, id: \.id) { location in
                                Button(action: {
                                    self.selectedLocationIndex = viewModel.getLocationIndex(for: location) ?? 0
                                    viewModel.fetchCharacters(location: location)
                                }) {
                                    if selectedLocationIndex == viewModel.getLocationIndex(for: location) {
                                        Text(location.name)
                                            .padding(.vertical, 12)
                                            .padding(.horizontal)
                                            .foregroundColor(Color.white)
                                            .background(Color("StatusBarColor"))
                                            .cornerRadius(25)
                                    } else {
                                        Text(location.name)
                                            .padding(.vertical, 12)
                                            .padding(.horizontal)
                                            .foregroundColor(Color.white)
                                            .background(Color("ButtonColor"))
                                            .cornerRadius(25)
                                    }
                                }
                                .onAppear {
                                    // Get next location page while api?.info.next != nil
                                    if viewModel.hasMoreLocations {
                                        viewModel.newLocations()
                                    }
                                }
                            }
                        } else {
//                            Locations loading view
                            ForEach(0 ..< 10, id: \.self) { _ in
                                Text("Loading")
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(10)
                                    .shimmering()
                            }
                        }
                    }
                    .frame(height: 50)
                }
                .padding(.horizontal, 10)

//                Characters view
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                        if viewModel.isCharacterLoading {
                            ForEach(0 ..< 10, id: \.self) { _ in
                                CharacterCellView(characterName: "", characterGender: RMCharacterGender.unknown, characterImage: "")
                                    .shimmering()
                            }
                        } else {
                            if let characters = viewModel.characters[viewModel.locations[selectedLocationIndex].name] {
                                ForEach(characters, id: \.id) { character in
                                    NavigationLink(destination: CharacterDetailView(character: character)) {
                                        CharacterCellView(characterName: character.name, characterGender: character.gender, characterImage: character.image)
                                            .padding()
                                    }
                                }
                            } else if viewModel.location(at: selectedLocationIndex)?.residents.count == 0 {
                                VStack {
                                    Text("Nobody lives here, Morty.")
                                        .font(.custom("Rick-and-Morty-Font", size: 25))
                                        .foregroundColor(Color("ButtonColor"))
                                        .padding()
                                    Image("MortyLook")
                                        .resizable()
                                        .frame(width: 200, height: 200)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle(Text(""), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("Logo")
                        .resizable()
                        .frame(width: 200, height: 80)
                }
            }
            .onReceive(viewModel.$locations) { locations in
                if let firstLocation = locations.first {
                    viewModel.fetchCharacters(location: firstLocation)
                }
            }
        }
        .background(Color("BackGroundColor"))
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
