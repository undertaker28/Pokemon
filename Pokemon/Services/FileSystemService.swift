//
//  FileSystemService.swift
//  Pokemon
//
//  Created by Pavel on 11.03.23.
//

import Foundation

protocol FileSystemService {
    func saveData(dataToSave: Data, fileName: String, folderName: String)
    func getData(fileName: String, folderName: String) -> Data?
    func dataToDictionary(data: Data) -> [String: String]?
    func dictionaryToData(dictionary: [String: String]) -> Data?
    func createOfflineFileIfNeeded()
}

final class FileSystemServiceImpl: FileSystemService {
    private let folderName = Constants.folderName
    private let fileName = Constants.fileName
    private let fileManager = FileManager.default
    
    // Saves data to a file with the given file name and folder name
    func saveData(dataToSave: Data, fileName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        guard let url = getFileURL(fileName: fileName, folderName: folderName) else {
            return
        }
        fileManager.createFile(atPath: url.path, contents: dataToSave)
    }
    
    // Retrieves data from a file with the given file name and folder name
    func getData(fileName: String, folderName: String) -> Data? {
        guard let url = getFileURL(fileName: fileName, folderName: folderName),
              fileManager.fileExists(atPath: url.path) else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
    
    // Converts data to a dictionary
    func dataToDictionary(data: Data) -> [String: String]? {
        guard let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: String] else {
            return nil
        }
        return dictionary
    }

    // Converts a dictionary to data
    func dictionaryToData(dictionary: [String: String]) -> Data? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary) else {
            return nil
        }
        return jsonData
    }
    
    // Creates an empty file if one doesn't exist already
    func createOfflineFileIfNeeded() {
        createFolderIfNeeded(folderName: folderName)
        guard let url = getFileURL(fileName: fileName, folderName: folderName),
              !fileManager.fileExists(atPath: url.path),
              let data = dictionaryToData(dictionary: [:]) else {
            return
        }
        saveData(dataToSave: data, fileName: fileName, folderName: folderName)
    }
    
    // Creates a folder with the given name if it doesn't exist already
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getFolderURL(folderName: folderName) else {
            return
        }
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("Error while creating directory. FolderName: \(folderName) Error: \(error)")
            }
        }
    }
    
    // Retrieves the URL for a folder with the given name
    private func getFolderURL(folderName: String) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    // Retrieves the URL for a file with the given file name and folder name
    private func getFileURL(fileName: String, folderName: String) -> URL? {
        guard let folderURL = getFolderURL(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(fileName)
    }
}
