//
//  UITableView.swift
//  Codeforces
//
//  Created by Madara2hor on 07.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

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

    func dequeueReusableCell<T: UITableViewCell>(
        for indexPath: IndexPath,
        reuseIdentifier: String? = nil
    ) -> T {
        return dequeueReusableCell(
            withIdentifier: reuseIdentifier ?? String(describing: T.self),
            for: indexPath
        ) as! T
    }
}
