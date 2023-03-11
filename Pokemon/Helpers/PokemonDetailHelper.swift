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
    
    var imageSubscription: AnyCancellable?
    var pokemonStatsSubcription: AnyCancellable?
    
    init(url: String) {
        getPokemonDetail(url: url)
    }
    
    func getPokemonDetail(url: String) {
        guard let url = URL(string: url) else { return }
        pokemonStatsSubcription = NetworkingService.download(url: url)
            .decode(type: PokemonDetail.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingService.handleCompletion, receiveValue: { [weak self] detailValue in
                self?.detail = detailValue
                self?.getPokemonImage(url: detailValue.sprites?.frontDefault ?? "")
                self?.pokemonStatsSubcription?.cancel()
            })
    }
    
    func getPokemonImage(url: String) {
        guard let url = URL(string: url) else { return }
        imageSubscription = NetworkingService.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingService.handleCompletion, receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
                self?.imageSubscription?.cancel()
            })
    }
}
