//
//  UITableView.swift
//  Codeforces
//
//  Created by Madara2hor on 07.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func register<T: UITableViewHeaderFooterView & CellRegistrable>(_ cellType: T.Type) {
        register(
            UINib(nibName: cellType.nibName, bundle: nil),
            forHeaderFooterViewReuseIdentifier: String(describing: cellType.self)
        )
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ cellType: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: cellType.self)) as! T
    }
    
    func register<T: CellRegistrable>(_ cellType: T.Type) {
        let nib = UINib(nibName: cellType.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: cellType.self))
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, reuseIdentifier: String? = nil) -> T {
        return dequeueReusableCell(
            withIdentifier: reuseIdentifier ?? String(describing: T.self),
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
        
        separatorStyle = .none
        backgroundView = emptyView
    }
    
    func restore() {
        separatorStyle = .singleLine
        backgroundView = nil
    }
}
