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
    let lastOnline: Int
}

final class UserHeaderView: UITableViewHeaderFooterView, CellRegistrable {
    
    private enum Constants {
        
        static let nibName = "UserHeaderView"
        static let height: CGFloat = 224
    }
    
    static var nibName: String { Constants.nibName }
    static var height: CGFloat { Constants.height }
    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userStatusImage: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var lastOnlineLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userImage.image = nil
        usernameLabel.text = nil
        lastOnlineLabel.text = nil
        
        userStatusImage.tintColor = .red
    }
    
    func setup(with model: UserHeaderViewModel) {
        if let urlImage = URL(string: "http:\(model.image)" ) {
            userImage.load(url: urlImage)
        } else {
            userImage.image = UIImage(systemName: "person")
        }
        
        usernameLabel.text = model.username
        
        if model.isOnline {
            userStatusImage.tintColor = .green
        } else {
            userStatusImage.tintColor = .red
        }
        
        
        
        lastOnlineLabel.text = "Был(-а) в сети \(getLastOnline(for: model.lastOnline))"
    }
    
    private func getLastOnline(for lastOnline: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(lastOnline))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = .current
        
        return dateFormatter.string(from: date)
    }
}
