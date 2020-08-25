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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setContestData(contest: Contest?) {
        self.contestName.text = contest?.name
        self.phase.text = contest?.phase.rawValue
        awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


