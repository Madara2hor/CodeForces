//
//  Int+Extension.swift
//  Codeforces
//
//  Created by Кирилл on 26.09.2022.
//  Copyright © 2022 Madara2hor. All rights reserved.
//

import Foundation

extension Int {
    
    var durationFromSeconds: String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let days = self / 86400
        
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
