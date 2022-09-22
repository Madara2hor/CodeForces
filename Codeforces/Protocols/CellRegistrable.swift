//
//  CellRegistrable.swift
//  Codeforces
//
//  Created by Кирилл on 22.09.2022.
//  Copyright © 2022 Madara2hor. All rights reserved.
//

import UIKit

protocol CellRegistrable: UITableViewCell {
    
    static var nibName: String { get }
}
