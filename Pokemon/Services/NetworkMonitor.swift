//
//  NetworkMonitor.swift
//  Pokemon
//
//  Created by Pavel on 10.03.23.
//

import Foundation
import Alamofire

final class NetworkMonitor: ObservableObject {
    @Published private(set) var isConnected = false
    @Published private(set) var isCellular = false
    @Published private(set) var isDisconnected = false
    
    private let reachabilityManager: NetworkReachabilityManager?
    
    init(reachabilityManager: NetworkReachabilityManager?) {
        self.reachabilityManager = reachabilityManager
    }
    
    public func startMonitoring() {
        reachabilityManager?.startListening(onUpdatePerforming: { [weak self] status in
            DispatchQueue.main.async {
                self?.isConnected = status == .reachable(.ethernetOrWiFi)
                self?.isCellular = status == .reachable(.cellular)
                self?.isDisconnected = status == .notReachable
            }
        })
    }
    
    public func stopMonitoring() {
        reachabilityManager?.stopListening()
    }
}
