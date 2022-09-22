//
//  UserCell.swift
//  Codeforces
//
//  Created by Madara2hor on 11.09.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    private enum Constants {
        
        static let reuseId = "UserCell"
    }
    
    static var reuseId: String { Constants.reuseId }

    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var handler: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.makeRounded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImage.image = nil
        handler.text = nil
    }
    
    func configure(user: User?) {
        handler.text = user?.handle
        
        if let url = user?.titlePhoto, let urlImage = URL(string: "http:\(url)" ) {
            profileImage.load(url: urlImage)
        }
        
        awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: Constants.reuseId, bundle: nil)
    }

}
