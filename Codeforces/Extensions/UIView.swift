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
    
    func setLoadingSubview() {
        let spinnerViewFrame: CGFloat = 100
        let loadingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: self.bounds.size.width,
                                               height: self.bounds.size.height))
        
        let spinnerView = UIView()
        let spinner = UIActivityIndicatorView()
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        
        spinner.style = .large
        spinner.startAnimating()
        spinner.color = .white
        
        spinnerView.addSubview(spinner)
        loadingView.addSubview(spinnerView)
        
        let spinnerViewConstraints: [NSLayoutConstraint] = [
            spinnerView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            spinnerView.heightAnchor.constraint(equalToConstant: spinnerViewFrame),
            spinnerView.widthAnchor.constraint(equalToConstant: spinnerViewFrame),
            spinner.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor)
            ]
        
        active(constraints: spinnerViewConstraints)
        
        spinnerView.layoutIfNeeded()
        spinnerView.makeRounded()
        spinnerView.makeTransparentBlue()
        
        loadingView.accessibilityIdentifier = "loadingView"
        
        
        self.addSubview(loadingView)
    }
    
    func showViewWithAnimation(duration: Double, delay: Double, anchor: NSLayoutConstraint, anchorConstant: CGFloat , view: UIView) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration,
                           delay: delay,
                           options: .curveEaseInOut,
                           animations: {
                            anchor.constant += anchorConstant + view.frame.width
                            view.makeTransparentBlue()
                            
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
                            view.backgroundColor = nil
                            
                            self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func setEmptySubview(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: 0,
                                             y: self.center.y / 1.5,
                                             width: self.bounds.size.width,
                                             height: self.bounds.size.height / 3))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.label
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        messageLabel.textColor = UIColor.systemGray
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        let constraints: [NSLayoutConstraint] = [
            messageLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20),
            messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20)
            ]
        
        active(constraints: constraints)
        
        titleLabel.text = title
        titleLabel.textAlignment = .center
        
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        emptyView.accessibilityIdentifier = "emptyView"
        
        self.addSubview(emptyView)
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
