//
//  String.swift
//  Twitter
//
//  Created by Madara2hor on 05.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation
import CommonCrypto

public extension String {
   
    var sha512: String {
        let data = self.data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        
        data.withUnsafeBytes{
            _ = CC_SHA512($0.baseAddress, CC_LONG(data.count), &digest)
        }
        
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
    
    func getTitledValue(title: String?, value: String?) -> String? {
        if let stringValue = value {
            if let title = title {
                return "\(title): \(stringValue)"
            } else {
                return "\(stringValue)"
            }
        } else if let title = title {
            return "\(title):"
        }
        
        return nil
    }
    
    func getTitledValue(title: String?, value: Int?) -> String? {
        if let intValue = value {
            if let title = title {
                return "\(title): \(intValue)"
            } else {
                return "\(intValue)"
            }
        } else if let title = title {
            return "\(title):"
        }
        
        return nil
    }
    
    func getDurationValue(title: String?, seconds: Int?) -> String? {
        if let timeInSeconds = seconds {
            if let title = title {
                return "\(title): \(String(describing: timeInSeconds).durationFromSeconds)"
            } else {
                return String(describing: timeInSeconds).durationFromSeconds
            }
        } else if let title = title {
            return "\(title):"
        }
        
        return nil
    }
    
    func getDateValue(title: String?, UNIX: Int?) -> String? {
        if let timeInUNIX = UNIX {
            if let title = title {
                return "\(title): \(String(describing: timeInUNIX).date)"
            } else {
                return String(describing: timeInUNIX).date
            }
        } else if let title = title {
            return "\(title):"
        }
        
        return nil
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
        
        var hours = intSeconds / 3600
        let minutes = (intSeconds % 3600) / 60
        let days = intSeconds / 86400
        
        if days > .zero {
            hours %= 24
        }
        
        var duration = ""
        
        if days > .zero {
            let firstDaysNumber = days / 10
            let lastDaysNumber = days % 10
            if firstDaysNumber == .zero {
                duration = "\(days) \(dayPostfix(firstDaysNumber: firstDaysNumber, lastDaysNumber: lastDaysNumber))"
            } else {
                duration = "\(days) \(dayPostfix(firstDaysNumber: firstDaysNumber, lastDaysNumber: lastDaysNumber))"
            }
        }
        
        if hours == .zero {
            return duration
        }
        
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
    
    private func dayPostfix(firstDaysNumber: Int, lastDaysNumber: Int) -> String {
        if firstDaysNumber == 1 && lastDaysNumber == 1 {
            return " дней "
        }
        
        if firstDaysNumber == .zero {
            switch lastDaysNumber {
            case 1:
                return " день "
            case 2...4:
                return " дня "
            default:
                return " дней "
            }
        }
        
        return " дней "
    }
}

extension String: LocalizedError {
    
    public var errorDescription: String? { self }
}
