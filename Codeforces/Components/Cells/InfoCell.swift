//
//  InfoCell.swift
//  Codeforces
//
//  Created by Кирилл on 22.09.2022.
//  Copyright © 2022 Madara2hor. All rights reserved.
//

import UIKit

struct InfoViewModel: Equatable {
    
    let title: String
    let info: String
}

struct InfoCellViewModel {
    
    let info: InfoViewModel
    let roundDelimeterInfo: RoundDelimeterInfo
}

final class InfoCell: UITableViewCell, CellRegistrable {
    
    private enum Constants {
        
        static let cornerRadius: CGFloat = 16
        static let nibName = "InfoCellView"
    }
    
    static var nibName: String { Constants.nibName }
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    
    @IBOutlet private weak var separatorView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        containerView.roundCorners(.allCorners, radius: .zero)
    }
    
    func update(with model: InfoCellViewModel) {
        titleLabel.text = model.info.title
        infoLabel.text = model.info.info
        
        separatorView.isHidden = model.roundDelimeterInfo.isDelimeterHidden
        
        guard let corners = model.roundDelimeterInfo.corners else {
            return
        }
        
        containerView.roundCorners(corners, radius: Constants.cornerRadius)
    }
}
