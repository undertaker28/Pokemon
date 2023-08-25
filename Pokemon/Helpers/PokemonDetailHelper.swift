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
    private var pokemonStatsSubcription: AnyCancellable?
    private let networkingService: NetworkingService
    
    init(url: URL, networkingService: NetworkingService) {
        self.networkingService = networkingService
        self.getPokemonDetail(url: url)
    }
    
    func getPokemonDetail(url: URL) {
        pokemonStatsSubcription = networkingService.download(url: url)
            .decode(type: PokemonDetail.self, decoder: JSONDecoder())
            .sink(receiveCompletion: networkingService.handleCompletion, receiveValue: { [weak self] detailValue in
                self?.detail = detailValue
                self?.pokemonStatsSubcription?.cancel()
            })
    }
}
