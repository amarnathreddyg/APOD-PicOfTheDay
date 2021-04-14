//
//  NetworkStatus.swift
//  Sample
//
//  Created by Amarnath Gopireddy on 4/14/21.
//

import Foundation
import Network

public enum ConnectionType {
    case wifi
    case ethernet
    case cellular
    case noInternet
}

class NetworkStatus {
    static public let shared = NetworkStatus()
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue(label: "monitor queue", qos: .userInitiated)
    var isOn: Bool = true
    var connType: ConnectionType = .noInternet
    var listener: ((Bool) -> Void)?

    private init() {
        self.monitor = NWPathMonitor()
        self.monitor.start(queue: queue)
    }

    func start() {
        self.monitor.pathUpdateHandler = { [weak self] path in
            self?.isOn = path.status == .satisfied
            self?.connType = self?.checkConnectionTypeForPath(path) ?? .noInternet
            self?.listener?(path.status == .satisfied)
        }
    }

    func stop() {
        self.monitor.cancel()
    }

    func checkConnectionTypeForPath(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        }

        return .noInternet
    }
}
