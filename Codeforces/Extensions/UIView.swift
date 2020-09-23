//
//  UIView.swift
//  Codeforces
//
//  Created by Madara2hor on 06.08.2020.
//  Copyright © 2020 Madara2hor. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    func makeRounded() {
        self.layer.cornerRadius = self.frame.height / 6
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func makeCircle() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func makeTransparentBlue() {
        self.backgroundColor = UIColor.buttonColor.withAlphaComponent(0.7)
    }
    
    func makeTransparentBlack() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 3.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
    }
    
    func showViewWithAnimation(duration: Double, delay: Double, anchor: NSLayoutConstraint, anchorConstant: CGFloat , view: UIView) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration,
                           delay: delay,
                           options: .curveEaseInOut,
                           animations: {
                            anchor.constant += anchorConstant + view.frame.width
                            view.alpha += 1
                            
                            self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func hideViewWithAnimation(duration: Double, delay: Double, anchor: NSLayoutConstraint, anchorConstant: CGFloat, view: UIView) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration,
                           delay: delay,
                           options: .curveEaseInOut,
                           animations: {
                            anchor.constant -= anchorConstant + view.frame.width
                            view.alpha -= 1
                            
                            self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func setLoadingSubview() {
        self.isUserInteractionEnabled = false
        let spinnerViewFrame: CGFloat = 100
        
        let spinnerView = UIView()
        let spinner = UIActivityIndicatorView()
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        
        spinner.style = .medium
        spinner.startAnimating()
        spinner.color = .white
        
        spinnerView.addSubview(spinner)
        self.addSubview(spinnerView)
        
        let spinnerViewConstraints: [NSLayoutConstraint] = [
            spinnerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            spinnerView.heightAnchor.constraint(equalToConstant: spinnerViewFrame),
            spinnerView.widthAnchor.constraint(equalToConstant: spinnerViewFrame),
            spinner.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor)
            ]
        
        active(constraints: spinnerViewConstraints)
        
        spinnerView.layoutIfNeeded()
        spinnerView.makeRounded()
        spinnerView.makeTransparentBlue()
        
        spinnerView.accessibilityIdentifier = "loadingView"
    }
        
    func setMessageSubview(title: String, message: String) {
        let messageView = UIView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.label
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        messageLabel.textColor = UIColor.systemGray
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        
        messageView.addSubview(titleLabel)
        messageView.addSubview(messageLabel)
        
        self.addSubview(messageView)
        
        let constraints: [NSLayoutConstraint] = [
            messageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            messageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant: -8),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 8),
            messageLabel.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant: -8),
            messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -8)
            ]
        
        active(constraints: constraints)
        
        messageView.layoutIfNeeded()
        
        titleLabel.text = title
        titleLabel.textAlignment = .center
        
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        messageView.accessibilityIdentifier = "messageView"
    }
    
    func active(constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            constraint.isActive = true
        }
    }
    
    func removeLoadingSubview() {
        guard let loadingView = getViewWithIdentifier(identifier: "loadingView") else { return }
        loadingView.removeFromSuperview()
        self.isUserInteractionEnabled = true
    }
    
    func removeMessageSubview() {
        guard let messageView = getViewWithIdentifier(identifier: "messageView") else { return }
        messageView.removeFromSuperview()
    }
    
    func getViewWithIdentifier(identifier: String) -> UIView? {
        for view in self.subviews {
            if view.accessibilityIdentifier == identifier {
                return view
            }
        }
        return nil
    }
    
}
