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
    
    func makeRounded() {
        self.layer.cornerRadius = self.frame.height / 5
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
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
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
        let spinnerViewFrame: CGFloat = 100
        
        let spinnerView = UIView()
        let spinner = UIActivityIndicatorView()
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        
        spinner.style = .large
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
        let emptyView = UIView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.label
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        messageLabel.textColor = UIColor.systemGray
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        self.addSubview(emptyView)
        
        let constraints: [NSLayoutConstraint] = [
            emptyView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            emptyView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            emptyView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -8),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 8),
            messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -8)
            ]
        
        active(constraints: constraints)
        
        emptyView.layoutIfNeeded()
        
        titleLabel.text = title
        titleLabel.textAlignment = .center
        
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        emptyView.accessibilityIdentifier = "emptyView"
        
    }
    
    func active(constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            constraint.isActive = true
        }
    }
    
    func removeLoadingSubview() {
        for view in self.subviews {
            if view.accessibilityIdentifier == "loadingView" {
                view.removeFromSuperview()
                break
            }
        }
    }
    
    func removeEmptySubview() {
        for view in self.subviews {
            if view.accessibilityIdentifier == "emptyView" {
                view.removeFromSuperview()
                break
            }
        }
    }
    
}
