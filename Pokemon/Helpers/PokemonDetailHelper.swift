//
//  PokemonDetailHelper.swift
//  Pokemon
//
//  Created by Pavel on 11.03.23.
//

import Foundation
import Combine
import SwiftUI

final class PokemonDetailHelper {
    @Published var image: UIImage? = nil
    @Published var detail: PokemonDetail?
    
    var pokemonStatsSubcription: AnyCancellable?
    
    init(url: String) {
        getPokemonDetail(url: url)
    }
    
    func getPokemonDetail(url: String) {
        guard let url = URL(string: url) else { return }
        pokemonStatsSubcription = NetworkingService.download(url: url)
            .decode(type: PokemonDetail.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingService.handleCompletion, receiveValue: { [weak self] detail in
                self?.detail = detail
                self?.pokemonStatsSubcription?.cancel()
            })
    }
}
