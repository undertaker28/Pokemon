//
//  NetworkMonitor.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    @Published private(set) var isConnected = false
    @Published private(set) var isCellular = false
    @Published private(set) var isDisconnected = false
    
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue.global()
    
    public func startMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.usesInterfaceType(.wifi)
                self?.isDisconnected = path.status == .unsatisfied
                self?.isCellular = path.usesInterfaceType(.cellular)
            }
        }
        
        networkMonitor.start(queue: workerQueue)
    }
    
    public func stopMonitoring() {
        networkMonitor.cancel()
    }
}
