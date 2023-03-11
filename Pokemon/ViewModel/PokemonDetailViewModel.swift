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
    @Published var detail: PokemonDetail?
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var isLoadingImage: Bool = false
    
    let dataService: PokemonDetailHelper
    
    private var cancellables = Set<AnyCancellable>()
    
    init(url: String) {
        self.dataService = PokemonDetailHelper(url: url)
        addSubscribers()
        self.isLoading = true
        self.isLoadingImage = true
    }
    
    func addSubscribers() {
        dataService.$image
            .sink { [weak self] returnedImage in
                self?.image = returnedImage
                self?.isLoadingImage = false
            }
            .store(in: &cancellables)
        
        dataService.$detail
            .sink { [weak self] returnedDetail in
                self?.detail = returnedDetail
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}
