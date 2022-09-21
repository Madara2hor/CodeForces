//
//  TweetCellx.swift
//  Twitter
//
//  Created by Madara2hor on 05.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class ContestCell: UITableViewCell {

    @IBOutlet weak var contestName: UILabel!
    @IBOutlet weak var phase: UILabel!
    
    func setContestData(contest: Contest?) {
        contestName.text = contest?.name
        phase.text = contest?.phase.rawValue
        
        awakeFromNib()
    }
}


