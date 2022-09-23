//
//  UserHeaderView.swift
//  Codeforces
//
//  Created by Кирилл on 22.09.2022.
//  Copyright © 2022 Madara2hor. All rights reserved.
//

import UIKit

struct UserHeaderViewModel {
    
    let image: String
    let username: String
    let isOnline: Bool
}

final class UserHeaderView: UITableViewHeaderFooterView, CellRegistrable {
    
    private enum Constants {
        
        static let nibName = "UserHeaderView"
    }
    
    static var nibName: String { Constants.nibName }
    
    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userStatusImage: UIImageView!
    @IBOutlet private weak var usernameContainer: UIView!
    @IBOutlet private weak var usernameTitle: UILabel!
    
    private var blurView: UIVisualEffectView?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userImage.image = nil
        usernameTitle.text = nil
        blurView?.removeFromSuperview()
        
        userStatusImage.tintColor = .red
    }
    
    func setup(with model: UserHeaderViewModel) {
        if let urlImage = URL(string: "http:\(model.image)" ) {
            userImage.load(url: urlImage)
        } else {
            userImage.image = UIImage(systemName: "person")
        }
        
        usernameTitle.text = model.username
        blurView = usernameContainer.configureBlur()
        
        if model.isOnline {
            userStatusImage.tintColor = .green
        } else {
            userStatusImage.tintColor = .red
        }
    }
}
