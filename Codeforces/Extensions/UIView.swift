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
    
    private enum Constants {
        
        static let blurViewTag = 101
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { layer.cornerRadius }
    }
    
    @discardableResult
    func configureBlur(alpha: CGFloat = .one, effect: UIBlurEffect.Style = .light) -> UIVisualEffectView {
        let style: UIBlurEffect.Style = effect
        
        if let blurEffectView = viewWithTag(Constants.blurViewTag) as? UIVisualEffectView {
            blurEffectView.effect = UIBlurEffect(style: style)
            blurEffectView.alpha = alpha
            
            return blurEffectView
        }
        
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.tag = Constants.blurViewTag
        blurEffectView.alpha = alpha
        
        insertSubview(blurEffectView, at: .zero)
        
        return blurEffectView
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
//
//    func makeRounded() {
//        layer.cornerRadius = frame.height / 6
//        layer.masksToBounds = true
//        clipsToBounds = true
//    }
    
//    func makeCircle() {
//        layer.cornerRadius = frame.height / 2
//        layer.masksToBounds = true
//        clipsToBounds = true
//    }
    
//    func makeTransparentBlue() {
//        backgroundColor = UIColor.buttonColor.withAlphaComponent(0.7)
//    }
//
//    func makeTransparentBlack() {
//        backgroundColor = UIColor.black.withAlphaComponent(0.7)
//    }
    
    func showViewWithAnimation(
        duration: Double,
        delay: Double,
        anchor: NSLayoutConstraint,
        anchorConstant: CGFloat,
        view: UIView
    ) {
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: duration,
                delay: delay,
                options: .curveEaseInOut,
                animations: { [weak self] in
                    anchor.constant += anchorConstant + view.frame.width
                    view.alpha += .one
                            
                    self?.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    
    func hideViewWithAnimation(
        duration: Double,
        delay: Double,
        anchor: NSLayoutConstraint,
        anchorConstant: CGFloat,
        view: UIView
    ) {
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: duration,
                delay: delay,
                options: .curveEaseInOut,
                animations: { [weak self] in
                    anchor.constant -= anchorConstant + view.frame.width
                    view.alpha -= .one
                            
                    self?.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    
    func setLoadingSubview() {
        isUserInteractionEnabled = false
        let spinnerViewFrame: CGFloat = 100
        
        let spinnerView = UIView()
        let spinner = UIActivityIndicatorView()
        let progress = UIProgressView()
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        progress.translatesAutoresizingMaskIntoConstraints = false
        
        spinner.style = .medium
        spinner.startAnimating()
        spinner.color = .white
        
        progress.setProgress(.zero, animated: false)
        progress.tintColor = UIColor.buttonColor
        
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
//        spinnerView.makeRounded()
//        spinnerView.makeTransparentBlue()
        
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
        
        addSubview(messageView)
        
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
        messageLabel.numberOfLines = .zero
        
        messageView.accessibilityIdentifier = "messageView"
    }
    
    func active(constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            constraint.isActive = true
        }
    }
    
    func removeLoadingSubview() {
        guard let loadingView = getViewWithIdentifier(identifier: "loadingView") else {
            return
        }
        
        loadingView.removeFromSuperview()
        isUserInteractionEnabled = true
    }
    
    func removeMessageSubview() {
        guard let messageView = getViewWithIdentifier(identifier: "messageView") else {
            return
        }
        
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
