//
//  NetworkingService.swift
//  Pokemon
//
//  Created by Pavel on 11.03.23.
//

import Foundation
import Combine

enum NetworkingErrors: Error {
    case informational(url: URL)
    case redirection(url: URL)
    case clientError(url: URL)
    case serverError(url: URL)
    case unknown(url: URL)
}

final class NetworkingService {
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0, url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        let folderName = "pokemonCash"
        if let response = output.response as? HTTPURLResponse,
           response.statusCode < 200 && response.statusCode >= 300 {
            throw NetworkingErrors.init(code: response.statusCode, url: url)
        }
        FileSystemService.instance.saveData(dataToSave: output.data, fileName: String(output.data.count), folderName: folderName)
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
