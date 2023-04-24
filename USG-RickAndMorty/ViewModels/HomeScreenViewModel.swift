//
//  HomeScreenViewModel.swift
//  USG-RickAndMorty
//
//  Created by Fatih Acıroğlu on 23.04.2023.
//

import Foundation
import SwiftUI

final class HomeScreenViewModel: ObservableObject {
    init() {
        fetchLocations()
    }

    @Published var locations: [RMLocation] = []
    @Published var characters: [String: [RMCharacter]] = [:]
    @Published var isLoading = true
    @Published var isCharacterLoading = true
    @Published var lastLocationPage = 1

    private var apiInfo: RMInfo?

    public func numberOfLocations() -> Int {
        return locations.count
    }
    
    public var hasMoreLocations: Bool {
        return apiInfo?.next != nil
    }


    public func location(at index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return locations[index]
    }

    public func getLocationIndex(for location: RMLocation) -> Int? {
        return locations.firstIndex(where: { $0.name == location.name })
    }

    
    
    private func getIds(residents: [String]) -> [String] {
        var ids = [String]()
        for resident in residents {
            let id = URL(string: resident)?.lastPathComponent ?? ""
            ids.append(id)
        }
        return ids
    }
    
    public func newLocations() {
        if apiInfo?.next == nil {
            return
        }
        lastLocationPage += 1
        fetchLocations()
    }

    public func fetchLocations() {
        let request = RMRequest(endpoint: .location, queryParameters: [URLQueryItem(name: "page", value: "\(lastLocationPage)")])
        RMService.shared.execute(
            request,
            expecting: RMGetAllLocationsResponse.self
        ) { [weak self] result in
            switch result {
            case let .success(model):
                DispatchQueue.main.async {
                    self?.apiInfo = model.info
                    self?.locations.append(contentsOf: model.results)
                    self?.isLoading = false
                }
            case let .failure(error):
                break
            }
        }
    }
    public func fetchCharacters(location: RMLocation) {
        let request = RMRequest(endpoint: .character, ids: getIds(residents: location.residents))
        RMService.shared.execute(request, expecting: [RMCharacter].self) { [weak self] result in
            switch result {
            case let .success(model):
                DispatchQueue.main.async {
                    if self?.characters.keys.contains(location.name) == true {
                        return
                    } else {
                        self?.characters[location.name] = model
                    }
                    self?.isCharacterLoading = false
                }
            case let .failure(error):
                break
            }
        }
    }
}
