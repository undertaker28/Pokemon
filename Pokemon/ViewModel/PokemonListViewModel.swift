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
    private(set) var pokemonMappingArray = [PokemonMappingInfo]()
    
    let dataHelper = PokemonListHelper(url: Endpoint.pokemons.url)
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func getPokemons() -> [PokemonMappingInfo] {
        if let pokemonListPage = pokemonListPage {
            pokemonMappingArray = pokemonListPage.results.compactMap { PokemonMappingInfo(id: getPokemonId(from: $0.url) ?? 0, name: $0.name) }
        }
        return pokemonMappingArray
    }
    
    private func getPokemonId(from url: String) -> Int? {
        guard let idString = url.split(separator: "/").last else {
            return nil
        }
        return Int(idString)
    }
    
    private func addSubscribers() {
        dataHelper.$pokemonListPage
            .sink { [weak self] returnedPage in
                self?.pokemonListPage = returnedPage
            }
            .store(in: &cancellables)
    }
    
    func toolbarItem(_ text: String, _ imageName: String, _ color: Color) -> some View {
        HStack(spacing: 10) {
            Text(text)
                .font(Font.custom(Constants.fontMarkProBold, size: 18))
                .foregroundColor(color)
            Image(systemName: imageName)
        }
    }
}
