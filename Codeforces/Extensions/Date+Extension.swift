//
//  Date.swift
//  Codeforces
//
//  Created by Madara2hor on 06.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

extension Date {
    
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970).rounded())
    }

    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
