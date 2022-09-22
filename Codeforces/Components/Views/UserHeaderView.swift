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
    let status: String
}

final class UserHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var usernameTitle: UILabel!
    @IBOutlet private weak var userStatus: UILabel!
    
    func setup(with model: UserHeaderViewModel) {
        if let urlImage = URL(string: "http:\(model.image)" ) {
            userImage.load(url: urlImage)
        } else {
            userImage.image = UIImage(systemName: "person")
        }
        
        userImage.makeRounded()
        
        usernameTitle.text = model.username
        userStatus.text = model.status
    }
}
