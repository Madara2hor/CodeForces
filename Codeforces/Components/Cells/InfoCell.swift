//
//  InfoCell.swift
//  Codeforces
//
//  Created by Madara2hor on 05.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell, CellRegistrable {
    
    private enum Constants {
        
        static let nibName = "InfoCellView"
    }
    
    static var nibName: String { Constants.nibName }

    @IBOutlet private weak var contestName: UILabel!
    @IBOutlet private weak var phase: UILabel!
    
    func setContestData(contest: Contest?) {
        contestName.text = contest?.name
        phase.text = contest?.phase.rawValue
    }
}



