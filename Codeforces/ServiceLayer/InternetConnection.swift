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

class InternetConnection {

    static let sharedIC = InternetConnection()

    private let queue = DispatchQueue.global(qos: .background)
    let monitor = NWPathMonitor()
    
    var presenters: [ConnectionMonitorProtocol]?

    init() {

        monitor.start(queue: queue)
        connectionMonitor()
    }

    func connectionMonitor() {
        monitor.pathUpdateHandler = { path in
            switch path.status {
            case .satisfied:
                print("Интернет соединение установлено")
                self.queue.async { [weak self] in
                    if let presenters = self?.presenters {
                        for presenter in presenters {
                            presenter.connectionSatisfied()
                        }
                    }
                    
                }
            case .unsatisfied:
                print("Интернет соединение отсутствует")
                self.queue.async { [weak self] in
                    if let presenters = self?.presenters {
                        for presenter in presenters {
                            presenter.connectionUnsatisfied()
                        }
                    }
                }
            default:
                break
            }
        }
    }


}
