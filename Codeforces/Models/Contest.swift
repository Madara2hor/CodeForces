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
    
    case CF = "CF"
    case IOI = "IOI"
    case ICPC = "ICPC"
}

enum ContestPhase: String, Codable {
    
    case BEFORE = "BEFORE"
    case CODING = "CODING"
    case PENDING_SYSTEM_TEST = "PENDING_SYSTEM_TEST"
    case SYSTEM_TEST = "SYSTEM_TEST"
    case FINISHED = "FINISHED"
}
