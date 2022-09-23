//
//  ActivityDisplayable.swift
//  DMVGenius
//
//  Created by Кирилл on 05.07.2022.
//  Copyright © 2022 MobileUp LLC. All rights reserved.
//

import UIKit

protocol ActivityDisplayable: AnyObject {
    var activityIndicator: UIActivityIndicatorView? { get set }
    
    func addActivityIndicator(with color: UIColor, isNeedBlurBackground: Bool)
    func removeActivityIndicator()
}

extension ActivityDisplayable where Self: UIView {
    
    func addActivityIndicator(with color: UIColor, isNeedBlurBackground: Bool = false) {
        guard activityIndicator == nil else {
            activityIndicator?.startAnimating()
            return
        }
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = color
        activityIndicator.startAnimating()
        
        layoutCenter(activityIndicator)
        configureBlur(alpha: isNeedBlurBackground ? .one : .zero)
        
        self.activityIndicator = activityIndicator
    }
    
    func removeActivityIndicator() {
        activityIndicator?.removeFromSuperview()
        
        activityIndicator = nil
    }
}

extension ActivityDisplayable where Self: UIViewController {
    
    func addActivityIndicator(with color: UIColor, isNeedBlurBackground: Bool = true) {
        let activityOverlayView = ActivityDisplayableOverlayView()
        activityOverlayView.isNeedBlurBackground = isNeedBlurBackground
        
        view.layoutSubview(activityOverlayView)
        
        activityOverlayView.addActivityIndicator(with: color)
    }
    
    func removeActivityIndicator() {
        view.subviews.forEach { view in
            guard let activityOverlayView = view as? ActivityDisplayableOverlayView else {
                return
            }
            
            activityOverlayView.removeActivityIndicator()
            activityOverlayView.removeFromSuperview()
        }
    }
}
