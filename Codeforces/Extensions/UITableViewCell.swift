//
//  UITableView.swift
//  Codeforces
//
//  Created by Кирилл on 22.09.2022.
//  Copyright © 2022 Madara2hor. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: CellRegistrable>(_ cellType: T.Type) {
        register(UINib(nibName: T.nibName, bundle: nil), forCellReuseIdentifier: String(describing: T.self))
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, reuseIdentifier: String? = nil) -> T {
        return dequeueReusableCell(
            withIdentifier: reuseIdentifier ?? String(describing: T.self),
            for: indexPath
        ) as! T
    }
}
