//
//  InternetConnection.swift
//  Codeforces
//
//  Created by Madara2hor on 02.09.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation
import Network

protocol ConnectionMonitorProtocol: class {
    func connectionSatisfied()
    func connectionUnsatisfied()
}

protocol InternetConnectionMonitorProtocol: class {
    func startMonitor()
    func stopMonitor()
}

class InternetConnection: InternetConnectionMonitorProtocol {

    static let sharedIC = InternetConnection()
    private let monitor = NWPathMonitor()
    
    var presenters: [ConnectionMonitorProtocol]?

    init() { }
    
    func startMonitor() {
        monitor.pathUpdateHandler = { path in
            switch path.status {
            case .satisfied:
                print("Интернет соединение установлено")
                if let presenters = self.presenters {
                    for presenter in presenters {
                        presenter.connectionSatisfied()
                    }
                }
            case .unsatisfied:
                print("Интернет соединение отсутствует")
                if let presenters = self.presenters {
                    for presenter in presenters {
                        presenter.connectionUnsatisfied()
                    }
                }
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

}
