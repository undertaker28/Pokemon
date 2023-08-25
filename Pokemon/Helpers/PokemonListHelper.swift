//
//  PokemonListHelper.swift
//  Pokemon
//
//  Created by Pavel on 11.03.23.
//

import Foundation
import Combine

final class PokemonListHelper {
    @Published private(set) var pokemonList: PokemonList? = nil
    private var pokemonListPageSubscription: AnyCancellable?
    private let folderName = Constants.folderName
    private let fileName = Constants.fileName
    private let fileSystemService: FileSystemService
    private let networkingService: NetworkingService

    init(url: URL, fileSystemService: FileSystemService, networkingService: NetworkingService) {
        self.fileSystemService = fileSystemService
        self.networkingService = networkingService
        self.downloadPage(url: url)
    }

    // Downloads a page of the PokemonList from the provided URL
    func downloadPage(url: URL) {
        // Create an empty offline data file if it doesn't already exist
        fileSystemService.createOfflineFileIfNeeded()

        // Attempt to retrieve the offline data dictionary from the file system
        guard let offlineDictionaryData = fileSystemService.getData(fileName: fileName, folderName: folderName),
              var offlineDictionary = fileSystemService.dataToDictionary(data: offlineDictionaryData) else {
            return
        }

        // If the URL for this page is already in the offline data dictionary, load the data from the corresponding file
        if let offlineDataFileName = offlineDictionary[url.absoluteString],
           let offlineData = fileSystemService.getData(fileName: offlineDataFileName, folderName: folderName) {
            do {
                self.pokemonList = try JSONDecoder().decode(PokemonList.self, from: offlineData)
                return
            } catch let error {
                print(error.localizedDescription)
            }
        }

        // If the page isn't in the offline data dictionary, download it and save it to the file system
        pokemonListPageSubscription = networkingService.download(url: url)
            .decode(type: PokemonList.self, decoder: JSONDecoder())
            .sink(receiveCompletion: networkingService.handleCompletion, receiveValue: { [weak self] pokemonListPage in
                self?.pokemonList = pokemonListPage

                // Generate a unique hash for this URL and use it as the filename for the offline data file
                let urlHash = "\(url.absoluteString.hashValue)"
                offlineDictionary[url.absoluteString] = urlHash

                // Save the updated offline data dictionary to the file system
                if let dictionaryData = self?.fileSystemService.dictionaryToData(dictionary: offlineDictionary) {
                    self?.fileSystemService.saveData(dataToSave: dictionaryData, fileName: self?.fileName ?? "", folderName: self?.folderName ?? "")
                }

                // Cancel the subscription to avoid memory leaks
                self?.pokemonListPageSubscription?.cancel()
            })
    }
}
