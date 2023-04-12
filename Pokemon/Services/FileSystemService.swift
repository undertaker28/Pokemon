//
//  FileSystemService.swift
//  Pokemon
//
//  Created by Pavel on 11.03.23.
//

import Foundation

final class FileSystemService {
    private let folderName = Constants.folderName
    private let fileName = Constants.fileName
    private let fileManager = FileManager.default
    
    func saveData(dataToSave: Data, fileName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        guard let url = getURLForData(fileName: fileName, folderName: folderName) else {
            return
        }
        fileManager.createFile(atPath: url.path, contents: dataToSave)
    }
    
    func getData(fileName: String, folderName: String) -> Data? {
        guard let url = getURLForData(fileName: fileName, folderName: folderName),
              fileManager.fileExists(atPath: url.path) else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
    
    func dataToDictionary(data: Data) -> [String: String]? {
        guard let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: String] else {
            return nil
        }
        return dictionary
    }
    
    func dictionaryToData(dictionary: [String: String]) -> Data? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary) else {
            return nil
        }
        return jsonData
    }
    
    func createOfflineFileIfNeeded() {
        createFolderIfNeeded(folderName: folderName)
        let emptyDictionary: [String: String] = [:]
        if let data = dictionaryToData(dictionary: emptyDictionary), getData(fileName: fileName, folderName: folderName) == nil {
            saveData(dataToSave: data, fileName: fileName, folderName: folderName)
        }
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else {
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
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForData(fileName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(fileName)
    }
}

