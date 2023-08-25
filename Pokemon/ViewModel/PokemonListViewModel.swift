//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by Pavel on 11.03.23.
//

import SwiftUI
import Combine
import Foundation

final class PokemonListViewModel: ObservableObject {
    @Published private(set) var pokemonListPage: PokemonList?
    
    let dataHelper = PokemonListHelper(url: Endpoint.pokemons.url, fileSystemService: FileSystemServiceImpl(), networkingService: NetworkingServiceImpl(fileSystemService: FileSystemServiceImpl()))
    
    private var cancellables = Set<AnyCancellable>()
    @Published var pokemons: [PokemonMappingInfo] = []
    private var isLoadingPage = false
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataHelper.$pokemonList
            .sink { [weak self] newList in
                guard let self = self else { return }
                self.pokemonListPage = newList
                if let results = newList?.results {
                    let newPokemons = results.compactMap { PokemonMappingInfo(id: self.getPokemonId(from: $0.url) ?? 0, name: $0.name) }
                    self.pokemons.append(contentsOf: newPokemons)
                    print(pokemons)
                }
            }
            .store(in: &cancellables)
    }
    
    private func getPokemonId(from url: String) -> Int? {
        guard let idString = url.split(separator: "/").last else {
            return nil
        }
        return Int(idString)
    }
    
    func getFilteredPokemons(searchText: String) -> [PokemonMappingInfo] {
        return searchText.isEmpty ? pokemons : pokemons.filter { $0.name.contains(searchText.lowercased()) }
    }
    
    func loadMoreContentIfNeeded(currentItem item: PokemonMappingInfo) {
        let thresholdIndex = pokemons.index(pokemons.endIndex, offsetBy: -1)
        if !isLoadingPage && pokemons.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            isLoadingPage = true
            if let urlString = pokemonListPage?.next,
               let pageUrl = URL(string: urlString) {
                dataHelper.downloadPage(url: pageUrl)
            }
            isLoadingPage = false
        }
    }
}
