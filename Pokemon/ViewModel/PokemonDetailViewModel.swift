//
//  PokemonDetailViewModel.swift
//  Pokemon
//
//  Created by Pavel on 11.03.23.
//

import Foundation
import Combine
import SwiftUI

final class PokemonDetailViewModel: ObservableObject {
    @Published private(set) var detail: PokemonDetail?
    @Published private(set) var isLoading: Bool = false
    
    let dataHelper: PokemonDetailHelper
    
    private var cancellables = Set<AnyCancellable>()
    
    init(url: URL) {
        self.dataHelper = PokemonDetailHelper(url: url)
        addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        dataHelper.$detail
            .sink { [weak self] returnedDetail in
                self?.detail = returnedDetail
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func backgroundColor(forType type: String) -> UIColor {
        switch type {
        case "fire": return .systemRed
        case "poison", "bug", "grass": return .systemGreen
        case "water": return .systemTeal
        case "electric": return .systemYellow
        case "psychic": return .systemPurple
        case "normal": return .systemOrange
        case "ground": return .systemGray
        case "flying": return .systemBlue
        case "fairy": return .systemPink
        default: return .systemIndigo
        }
    }
}
