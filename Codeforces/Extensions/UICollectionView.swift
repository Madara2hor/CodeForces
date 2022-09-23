//
//  UICollectionView.swift
//  Codeforces
//
//  Created by Madara2hor on 23.09.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<T: CellRegistrable>(_ cellType: T.Type) {
        let nib = UINib(nibName: cellType.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: String(describing: cellType.self))
    }

    func dequeueReusableCell<T: UICollectionViewCell>(
        for indexPath: IndexPath,
        reuseIdentifier: String? = nil
    ) -> T {
        return dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier ?? String(describing: T.self),
            for: indexPath
        ) as! T
    }
    
    func setMessageBackgroundView(title: String, message: String) {
        let emptyView = UIView(
            frame: CGRect(
                x: center.x,
                y: center.y,
                width: bounds.size.width,
                height: bounds.size.height
            )
        )
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.label
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        messageLabel.textColor = UIColor.systemGray
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        let constraints: [NSLayoutConstraint] = [
            messageLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20),
            messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20)
        ]
        
        for constraint in constraints {
            constraint.isActive = true
        }
        
        titleLabel.text = title
        titleLabel.textAlignment = .center
        
        messageLabel.text = message
        messageLabel.numberOfLines = .zero
        messageLabel.textAlignment = .center
        
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
