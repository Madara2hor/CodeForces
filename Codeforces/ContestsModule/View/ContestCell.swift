//
//  ContestCell.swift
//  Codeforces
//
//  Created by Madara2hor on 05.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class ContestCell: UITableViewCell, CellRegistrable {
    
    private enum Constants {
        
        static let nibName = "ContestCellView"
    }
    
    static var nibName: String { Constants.nibName }

    @IBOutlet private weak var contestNameLabel: UILabel!
    @IBOutlet private weak var phaseLabel: UILabel!
    
    func update(with contest: Contest?) {
        contestNameLabel.text = contest?.name
        
        guard let phase = contest?.phase else {
            phaseLabel.text = nil
            return
        }
        
        if let time = contest?.relativeTimeSeconds {
            if phase == .before {
                phaseLabel.text = "\(phase.localizedValue): \(String(describing: -time).durationFromSeconds)"
            } else if phase == .coding {
                phaseLabel.text = "\(phase.localizedValue): \(String(describing: time).durationFromSeconds)"
            } else {
                phaseLabel.text = phase.localizedValue
            }
        } else {
            phaseLabel.text = phase.localizedValue
        }
    }
}



