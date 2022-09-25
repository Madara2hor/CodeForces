//
//  Contest.swift
//  Codeforces
//
//  Created by Madara2hor on 05.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation

struct Contest: Codable {
    
    var id: Int
    var name: String
    var type: ContestType
    var phase: ContestPhase
    var frozen: Bool
    var durationSeconds: Int
    var startTimeSeconds: Int?
    var relativeTimeSeconds: Int?
    var preparedBy: String?
    var websiteUrl: String?
    var description: String?
    var difficulty: Int?
    var kind: String?
    var icpcRegion: String?
    var country: String?
    var city: String?
    var season: String?
}

enum ContestType: String, Codable {
    
    case cf = "CF"
    case ioi = "IOI"
    case icpc = "ICPC"
}

enum ContestPhase: String, Codable, CaseIterable {
    
    case coding = "CODING"
    case before = "BEFORE"
    case pendingSystemTest = "PENDING_SYSTEM_TEST"
    case systemTest = "SYSTEM_TEST"
    case finished = "FINISHED"
    
    var localizedValue: String {
        switch self {
        case .coding:
            return "Идет"
        case .before:
            return "До начала"
        case .pendingSystemTest:
            return "Ожидается проверка"
        case .systemTest:
            return "Идет проверка"
        case .finished:
            return "Завершено"
        }
    }
}
