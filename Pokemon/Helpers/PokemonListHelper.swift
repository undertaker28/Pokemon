//
//  PokemonListHelper.swift
//  Pokemon
//
//  Created by Pavel on 11.03.23.
//

import Foundation
import Combine

final class PokemonListHelper {
    @Published private(set) var pokemonListPage: PokemonList? = nil
    private var pokemonListPageSubscription: AnyCancellable?
    private let folderName = Constants.folderName
    private let fileName = Constants.fileName
    private let fileSystemService = FileSystemService()

    init(url: URL) {
        getPage(url: url)
    }

    func getPage(url: URL) {
        fileSystemService.createOfflineFileIfNeeded()

        guard let dataOfOfflineDictionary = FileSystemService().getData(fileName: fileName, folderName: folderName) else {
            return
        }
        var offlineDictionary = FileSystemService().dataToDictionary(data: dataOfOfflineDictionary)

        if let offlineDataFileName = offlineDictionary?[url.absoluteString],
           let offlineData = fileSystemService.getData(fileName: offlineDataFileName, folderName: folderName) {
            do {
                self.pokemonListPage = try JSONDecoder().decode(PokemonList.self, from: offlineData)
                return
            } catch let error {
                print(error.localizedDescription)
            }
        }

        pokemonListPageSubscription = NetworkingService.download(url: url)
            .decode(type: PokemonList.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingService.handleCompletion, receiveValue: { [weak self] pageValue in
                self?.pokemonListPage = pageValue
                print(url.absoluteString.hashValue)
                offlineDictionary?[url.absoluteString] = "\(url.absoluteString.hashValue)"
                if let dictionaryData = self?.fileSystemService.dictionaryToData(dictionary: offlineDictionary ?? [:]) {
                    self?.fileSystemService.saveData(dataToSave: dictionaryData, fileName: self?.fileName ?? "", folderName: self?.folderName ?? "")
                }
                self?.pokemonListPageSubscription?.cancel()
            })
    }
}
