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
    
    let dataHelper = PokemonListHelper(url: Endpoint.pokemons.url)
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func getPokemons() -> [PokemonMappingInfo] {
        guard let pokemonListPage = pokemonListPage else { return [] }
        return pokemonListPage.results.compactMap { PokemonMappingInfo(id: getPokemonId(from: $0.url) ?? 0, name: $0.name) }
    }
    
    private func getPokemonId(from url: String) -> Int? {
        guard let idString = url.split(separator: "/").last else {
            return nil
        }
        return Int(idString)
    }
    
    private func addSubscribers() {
        dataHelper.$pokemonList
            .map { $0 }
            .assign(to: \.pokemonListPage, on: self)
            .store(in: &cancellables)
    }
    
    func getFilteredPokemons(searchText: String) -> [PokemonMappingInfo] {
        return searchText.isEmpty ? getPokemons() : getPokemons().filter { $0.name.contains(searchText.lowercased()) }
    }
}
