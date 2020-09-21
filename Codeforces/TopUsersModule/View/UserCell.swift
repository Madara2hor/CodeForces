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
    @IBOutlet weak var rating: UILabel!
    var loadedImage: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.makeRounded()
        self.makeRounded()
        self.setShadow()
    }
    
    override func prepareForReuse() {
        profileImage.image = nil
    }
    
    func configure(user: User?) {
        self.handler.text = user?.handle
        self.rating.text = String().getTitledValue(title: nil, value: user?.rating)
        if let url = user?.titlePhoto, let urlImage = URL(string: "http:\(url)" ) {
            
            if loadedImage == nil {
                self.profileImage.load(url: urlImage)
                loadedImage = profileImage.image
            } else {
                profileImage.image = loadedImage
            }
        }
        
        awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "UserCell", bundle: nil)
    }

}
