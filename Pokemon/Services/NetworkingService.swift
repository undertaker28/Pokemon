//
//  NetworkingService.swift
//  Pokemon
//
//  Created by Pavel on 11.03.23.
//

import Foundation
import Combine

protocol NetworkingService {
    func download(url: URL) -> AnyPublisher<Data, Error>
    func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data
    func handleCompletion(completion: Subscribers.Completion<Error>)
}

enum NetworkingErrors: Error {
    case informational(url: URL)
    case redirection(url: URL)
    case clientError(url: URL)
    case serverError(url: URL)
    case unknown(url: URL)
}

final class NetworkingServiceImpl: NetworkingService {
    private let fileSystemService: FileSystemService
    
    init(fileSystemService: FileSystemService) {
        self.fileSystemService = fileSystemService
    }
    
    func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try self.handleURLResponse(output: $0, url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        let folderName = Constants.folderName
        if let response = output.response as? HTTPURLResponse,
           response.statusCode < 200 && response.statusCode >= 300 {
            throw NetworkingErrors.init(code: response.statusCode, url: url)
        }
        fileSystemService.saveData(dataToSave: output.data, fileName: String(output.data.count), folderName: folderName)
        return output.data
    }
    
    func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
