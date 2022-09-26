//
//  String.swift
//  Codeforces
//
//  Created by Madara2hor on 05.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
   
    var sha512: String {
        let data = data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        
        data.withUnsafeBytes{
            _ = CC_SHA512($0.baseAddress, CC_LONG(data.count), &digest)
        }
        
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
    
    var date: String {
       guard let doubleDate = Double(self) else {
           return "Invalid date"
       }
       
       let date = Date(timeIntervalSince1970: doubleDate)
       let dateFormatter = DateFormatter()
       dateFormatter.timeStyle = .short
       dateFormatter.dateStyle = .short
       dateFormatter.timeZone = .current
       
       let localDate = dateFormatter.string(from: date)
       
       return localDate
    }
       
    var durationFromSeconds: String {
        guard let intSeconds = Int(self) else {
            return "Invalid time"
        }
        
        let hours = intSeconds / 3600
        let minutes = (intSeconds % 3600) / 60
        let days = intSeconds / 86400
        
        if days > .zero {
            return durationFor(days: days)
        }
        
        var duration: String = .empty
        
        if hours < 10 {
            duration += "0\(hours):"
        } else {
            duration += "\(hours):"
        }
        
        if minutes < 10 {
            duration += "0\(minutes)"
        } else {
            duration += "\(minutes)"
        }
        
        return duration
    }
    
    private func durationFor(days: Int) -> String {
        let appedDays = days + 1
        let weeks = appedDays / 7
        let months = appedDays / 30
        
        if months > .zero {
            switch months {
            case 1:
                return "\(months) месяц "
            case 2...4:
                return "\(months) месяца "
            default:
                return "\(months) месяцев "
            }
        }
        
        if weeks > .zero && appedDays != 7 {
            switch weeks {
            case 1:
                return "\(weeks) неделя "
            case 2...4:
                return "\(weeks) недели "
            default:
                return "\(weeks) недель "
            }
        }
        
        switch appedDays {
        case 1:
            return "\(appedDays) день "
        case 2...4:
            return "\(appedDays) дня "
        default:
            return "\(appedDays) дней "
        }
    }
}
