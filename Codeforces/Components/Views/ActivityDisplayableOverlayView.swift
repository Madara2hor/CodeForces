//
//  ActivityDisplayableOverlayView.swift
//  DMVGenius
//
//  Created by Кирилл on 08.07.2022.
//  Copyright © 2022 MobileUp LLC. All rights reserved.
//

import UIKit

final class ActivityDisplayableOverlayView: UIView, ActivityDisplayable {
    
    var activityIndicator: UIActivityIndicatorView?
    var isNeedBlurBackground: Bool = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let blurView = configureBlur(alpha: isNeedBlurBackground ? .one : .zero)
        blurView.isUserInteractionEnabled = false
    }
}
