//
//  UserRatingCell.swift
//  Codeforces
//
//  Created by Madara2hor on 07.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class UserRatingCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setRatingData(user: User?) {
        self.username.text = user?.handle
        self.rating.text = String().getTitledValue(title: nil, value: user?.rating)
        
        awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
