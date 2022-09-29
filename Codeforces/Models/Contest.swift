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

extension Contest {
    
    func getInfoModel() -> [InfoViewModel] {
        var contestInfo: [InfoViewModel] = []
        
        if let startTime = startTimeSeconds {
            contestInfo.append(InfoViewModel(
                title: "Начало соревнования",
                info: Double(startTime).date
            ))
        }
        contestInfo.append(InfoViewModel(
            title: "Длительность",
            info: durationSeconds.durationFromSeconds
        ))
        if let beforeStart = relativeTimeSeconds {
            if beforeStart > .zero {
                contestInfo.append(InfoViewModel(
                    title: "Идет",
                    info: beforeStart.durationFromSeconds
                ))
            } else {
                contestInfo.append(InfoViewModel(
                    title: "До начала",
                    info: (-beforeStart).durationFromSeconds
                ))
            }
        }
        if let prepared = preparedBy {
            contestInfo.append(InfoViewModel(
                title: "Содатель",
                info: prepared
            ))
        }
        if let website = websiteUrl {
            contestInfo.append(InfoViewModel(
                title: "Сайт",
                info: website
            ))
        }
        if let description = description {
            contestInfo.append(InfoViewModel(
                title: "Описание",
                info: description
            ))
        }
        if let difficulty = difficulty {
            contestInfo.append(InfoViewModel(
                title: "Сложность",
                info: "\(difficulty)"
            ))
        }
        if let kind = kind {
            contestInfo.append(InfoViewModel(
                title: "Тип соревнования",
                info: kind
            ))
        }
        contestInfo.append(InfoViewModel(
            title: "Система оценки",
            info: type.rawValue
        ))
        if let region = icpcRegion {
            contestInfo.append(InfoViewModel(
                title: "Регион",
                info: region
            ))
        }
        if let country = country {
            contestInfo.append(InfoViewModel(
                title: "Страна",
                info: country
            ))
        }
        if let city = city {
            contestInfo.append(InfoViewModel(
                title: "Город",
                info: city
            ))
        }
        if let season = season {
            contestInfo.append(InfoViewModel(
                title: "Сезон",
                info: season
            ))
        }
        
        return contestInfo
    }
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
