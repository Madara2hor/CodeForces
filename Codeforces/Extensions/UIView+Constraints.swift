//
//  UIView+Constraints.swift
//  DMVGenius
//
//  Created by Nikolai Timonin on 16.06.2022.
//  Copyright © 2022 MobileUp LLC. All rights reserved.
//

import UIKit

struct LayoutInsets {

    static var zero: LayoutInsets { self.init(top: 0, left: 0, bottom: 0, right: 0) }

    public var top: CGFloat?
    public var left: CGFloat?
    public var bottom: CGFloat?
    public var right: CGFloat?

    static func insets(
        top: CGFloat? = 0,
        left: CGFloat? = 0,
        bottom: CGFloat? = 0,
        right: CGFloat? = 0
    ) -> LayoutInsets {
        return LayoutInsets(top: top, left: left, bottom: bottom, right: right)
    }
}


struct LayoutDimension: OptionSet {

    let rawValue: Int

    static let height = LayoutDimension(rawValue: 1)
    static let width = LayoutDimension(rawValue: 2)
}

extension UIView {
    
    func layoutCenterHorizontally(_ view: UIView, offset: CGFloat = 0) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offset).isActive = true
    }

    func layoutCenter(_ view: UIView, xOffset: CGFloat = 0, yOffset: CGFloat = 0) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        view.centerXAnchor.constraint(equalTo: centerXAnchor, constant: xOffset).isActive = true
        view.centerYAnchor.constraint(equalTo: centerYAnchor, constant: yOffset).isActive = true
    }

    func layoutSubview(
        _ view: UIView,
        with insets: LayoutInsets = .insets(top: 0, left: 0, bottom: 0, right: 0),
        safe: Bool = false
    ) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        if let top = insets.top {
            view.topAnchor.makeConstraint(equalTo: getTopAnchor(safe: safe), constant: top)
        }

        if let left = insets.left {
            view.leadingAnchor.makeConstraint(equalTo: getLeadingAnchor(safe: safe), constant: left)
        }

        if let bottom = insets.bottom {
            view.bottomAnchor.makeConstraint(equalTo: getBottomAnchor(safe: safe), constant: -bottom)
        }

        if let right = insets.right {
            view.trailingAnchor.makeConstraint(equalTo: getTrailingAnchor(safe: safe), constant: -right)
        }
    }
    
    func layoutSize(height: CGFloat? = nil, width: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }

    func layoutEqualSize(to view: UIView, dimensitons: LayoutDimension = [.height, .width]) {
        translatesAutoresizingMaskIntoConstraints = false

        if dimensitons.contains(.height) {
            heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        }

        if dimensitons.contains(.width) {
            widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        }
    }
    
}

extension UIView {

    func getTopAnchor(safe: Bool) -> NSLayoutYAxisAnchor {
        return safe ? safeAreaLayoutGuide.topAnchor : topAnchor
    }

    func getBottomAnchor(safe: Bool) -> NSLayoutYAxisAnchor {
        return safe ? safeAreaLayoutGuide.bottomAnchor : bottomAnchor
    }

    func getLeadingAnchor(safe: Bool) -> NSLayoutXAxisAnchor {
        return safe ? safeAreaLayoutGuide.leadingAnchor : leadingAnchor
    }

    func getTrailingAnchor(safe: Bool) -> NSLayoutXAxisAnchor {
        return safe ? safeAreaLayoutGuide.trailingAnchor : trailingAnchor
    }
}

extension NSLayoutAnchor {

    @objc func makeConstraint(equalTo anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat) {
        constraint(equalTo: anchor, constant: constant).isActive = true
    }
}
