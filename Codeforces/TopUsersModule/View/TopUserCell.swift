//
//  TopUserCell.swift
//  Codeforces
//
//  Created by Кирилл on 24.09.2022.
//  Copyright © 2022 Madara2hor. All rights reserved.
//

import UIKit

class TopUserCell: UITableViewCell, CellRegistrable {

    private enum Constants {
        
        static let nibName: String = "TopUserCellView"
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
            ImageChaceUtil.shared.image(for: urlImage) { [weak self] image in
                self?.profileImageView.image = image
            }
        } else {
            profileImageView.image = UIImage(systemName: "person")
        }
        
        usernameLabel.text = user?.handle
        if let rating = user?.rating {
            userRatingLabel.text = "Рейтинг: \(rating)"
        }
    }
}
