//
//  RoundCornersService.swift
//  Codeforces
//
//  Created by Кирилл on 27.09.2022.
//  Copyright © 2022 Madara2hor. All rights reserved.
//

import UIKit

struct RoundDelimeterInfo {
    
    let corners: UIRectCorner?
    let isDelimeterHidden: Bool
}

final class RoundCornersService {
    
    static func getRoundDelimeterInfo<T: Equatable>(for item: T, allItems: [T]) -> RoundDelimeterInfo {
        if item == allItems.first && item == allItems.last {
            return RoundDelimeterInfo(corners: .allCorners, isDelimeterHidden: true)
        } else if item == allItems.first {
            return RoundDelimeterInfo(corners: .top, isDelimeterHidden: false)
        } else if item == allItems.last {
            return RoundDelimeterInfo(corners: .bottom, isDelimeterHidden: true)
        }
            
        return RoundDelimeterInfo(corners: nil, isDelimeterHidden: false)
    }
}
