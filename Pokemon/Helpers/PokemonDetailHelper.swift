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
    @Published private(set) var detail: PokemonDetail?
    
    var pokemonStatsSubcription: AnyCancellable?
    
    init(url: URL) {
        getPokemonDetail(url: url)
    }
    
    func getPokemonDetail(url: URL) {
        pokemonStatsSubcription = NetworkingService.download(url: url)
            .decode(type: PokemonDetail.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingService.handleCompletion, receiveValue: { [weak self] detailValue in
                self?.detail = detailValue
                self?.pokemonStatsSubcription?.cancel()
            })
    }
}
