//
//  InfoCell.swift
//  Codeforces
//
//  Created by Кирилл on 22.09.2022.
//  Copyright © 2022 Madara2hor. All rights reserved.
//

import UIKit

final class InfoCell: UITableViewCell, CellRegistrable {
    
    private enum Constants {
        
        static let nibName = "InfoCellView"
    }
    
    static var nibName: String { Constants.nibName }
    
    @IBOutlet private weak var infoLabel: UILabel!
    
    func update(with info: String) {
        infoLabel.text = info
    }
}
