//
//  Double+Extension.swift
//  Codeforces
//
//  Created by Кирилл on 26.09.2022.
//  Copyright © 2022 Madara2hor. All rights reserved.
//

import Foundation

extension Double {
    
    var date: String {
       let date = Date(timeIntervalSince1970: self)
       let dateFormatter = DateFormatter()
       dateFormatter.timeStyle = .short
       dateFormatter.dateStyle = .short
       dateFormatter.timeZone = .current
       
       return dateFormatter.string(from: date)
    }
}
