//
//  UserCell.swift
//  Codeforces
//
//  Created by Madara2hor on 11.09.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell, CellRegistrable {
    
    private enum Constants {
        
        static let nibName = "UserCell"
    }
    
    static var nibName: String { Constants.nibName }

    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var usernameContainer: UIView!
    @IBOutlet private weak var handler: UILabel!
    
    private var blurView: UIVisualEffectView?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImage.image = nil
        handler.text = nil
        blurView?.removeFromSuperview()
    }
    
    func setup(with user: User?) {
        if let url = user?.titlePhoto, let urlImage = URL(string: "http:\(url)" ) {
            profileImage.load(url: urlImage)
        }
        
        handler.text = user?.handle
        blurView = usernameContainer.configureBlur(effect: .dark)
    }
}
