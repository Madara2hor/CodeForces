//
//  NewTopUserCell.swift
//  Codeforces
//
//  Created by Кирилл on 24.09.2022.
//  Copyright © 2022 Madara2hor. All rights reserved.
//

import UIKit

class NewTopUserCell: UITableViewCell, CellRegistrable {

    private enum Constants {
        
        static let nibName: String = "NewTopUserCellView"
    }
    
    static var nibName: String { Constants.nibName }
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var userRatingLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = UIImage(systemName: "person")
        usernameLabel.text = nil
        userRatingLabel.text = nil
    }
    
    func update(with user: User?) {
        if let url = user?.titlePhoto, let urlImage = URL(string: "http:\(url)" ) {
            profileImageView.load(url: urlImage)
        } else {
            profileImageView.image = UIImage(systemName: "person")
        }
        
        usernameLabel.text = user?.handle
        if let rating = user?.rating {
            userRatingLabel.text = "Рейтинг: \(rating)"
        }
    }
}
