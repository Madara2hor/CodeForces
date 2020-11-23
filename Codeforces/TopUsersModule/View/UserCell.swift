//
//  UserCell.swift
//  Codeforces
//
//  Created by Madara2hor on 11.09.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    static let identifier = "UserCell"

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var handler: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImage.makeRounded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
    }
    
    func configure(user: User?) {
        self.handler.text = user?.handle
        if let url = user?.titlePhoto, let urlImage = URL(string: "http:\(url)" ) {
            self.profileImage.load(url: urlImage)
        }
        
        awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "UserCell", bundle: nil)
    }

}
