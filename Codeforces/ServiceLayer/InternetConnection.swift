//
//  InternetConnection.swift
//  Codeforces
//
//  Created by Madara2hor on 02.09.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation
import Network

protocol ConnectionMonitorProtocol: AnyObject {
    
    func connectionSatisfied()
    func connectionUnsatisfied()
}

protocol InternetConnectionMonitorProtocol: AnyObject {
    
    func startMonitor()
    func stopMonitor()
}

class InternetConnection: InternetConnectionMonitorProtocol {

    static let sharedIC = InternetConnection()
    private let monitor = NWPathMonitor()
    
    var presenters: [ConnectionMonitorProtocol]?

    init() { }
    
    func startMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            switch path.status {
            case .satisfied:
                print("Интернет соединение установлено")
                
                self?.connectionChanged(on: true)
            case .unsatisfied:
                print("Интернет соединение отсутствует")
                
                self?.connectionChanged(on: false)
            default:
                break
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitor() {
        monitor.cancel()
    }
    
    private func connectionChanged(on isConnected: Bool) {
        guard let presenters = self.presenters else {
            return
        }
        
        for presenter in presenters {
            DispatchQueue.main.async {
                if isConnected {
                    presenter.connectionSatisfied()
                } else {
                    presenter.connectionUnsatisfied()
                }
            }
        }
    }
}
