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
    
    private enum Constants {
        
        static let queueLabel = "com.InternetConnection.MonitorQueue"
    }

    static let shared = InternetConnection()
    
    var presenters: [ConnectionMonitorProtocol]?
    
    private let monitorQueue = DispatchQueue(label: Constants.queueLabel)
    private let monitor = NWPathMonitor()

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
        
        monitor.start(queue: monitorQueue)
    }
    
    func stopMonitor() {
        monitor.cancel()
    }
    
    private func connectionChanged(on isConnected: Bool) {
        guard let presenters = presenters else {
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
