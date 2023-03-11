//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by Pavel on 11.03.23.
//

import Foundation
import Combine

final class PokemonListViewModel: ObservableObject {
    @Published private(set) var pokemonListPage: PokemonList?
    
    let dataService = PokemonListHelper(url: "https://pokeapi.co/api/v2/pokemon")
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func getPokemons() -> [PokemonInfo] {
        return pokemonListPage?.results ?? []
    }
    
    private func addSubscribers() {
        dataService.$pokemonListPage
            .sink { [weak self] returnedPage in
                self?.pokemonListPage = returnedPage
            }
            .store(in: &cancellables)
    }
}
