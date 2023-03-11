//
//  PokemonListHelper.swift
//  Pokemon
//
//  Created by Pavel on 11.03.23.
//

import Foundation
import Combine

final class PokemonListHelper {
    @Published var pokemonListPage: PokemonList? = nil
    var pokemonListPageSubscription: AnyCancellable?
    private let folderName = "pokemonCash"
    private let fileName = "pokemonOfflineData"
    
    init(url: String) {
        getPage(url: url)
    }
    
    func getPage(url: String) {
        FileSystemService.instance.createOfflineFileIfNeeded()
        
        guard let dataOfOfflineDictionary = FileSystemService.instance.getData(fileName: fileName, folderName: folderName) else { return }
        let offlineDictionary = FileSystemService.instance.dataToDictionary(data: dataOfOfflineDictionary)
        
        guard let url = URL(string: url) else { return }
        
        var loadFlag = false
        for item in offlineDictionary {
            if item.key == url.absoluteString {
                print("The page is already in the dictionary", url.absoluteString)
                loadFlag = true
            }
        }
        
        if loadFlag {
            guard let offlineData = FileSystemService.instance.getData(fileName: offlineDictionary[url.absoluteString] ?? "", folderName: folderName) else { return }
            do {
                self.pokemonListPage = try JSONDecoder().decode(PokemonList.self, from: offlineData)
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            pokemonListPageSubscription = NetworkingService.download(url: url)
                .decode(type: PokemonList.self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingService.handleCompletion, receiveValue: { [weak self] pageValue in
                    self?.pokemonListPage = pageValue
                    self?.pokemonListPageSubscription?.cancel()
                })
        }
    }
}
