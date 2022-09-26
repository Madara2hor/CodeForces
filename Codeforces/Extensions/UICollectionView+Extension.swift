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
}
