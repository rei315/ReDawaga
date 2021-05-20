//
//  NetworkMonitor.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/05/06.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    private init() {
        self.monitor = NWPathMonitor()
    }
    
    public func startMonitor() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.stopMonitor()
            let isConnected: Bool = path.status == .satisfied ? true : false
            
            NetworkMonitorActionCreator.fetchIsConnected(isConnected: isConnected)
        }
    }
    
    func stopMonitor() {
        monitor.cancel()
    }
}
