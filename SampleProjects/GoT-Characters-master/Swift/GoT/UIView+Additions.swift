//
//  UIView+Additions.swift
//  ParallaxDemo
//
//  Created by Paciej on 18/10/15.
//  Copyright (c) 2015 Paciej. All rights reserved.
//

import UIKit

extension UIView {
    /** Creates constraints from array of visual format language strings and adds
     * them to the view*/
    class func addConstraints(fromStrings strings: [Any]?, withMetrics metrics: [AnyHashable : Any]?, andViews views: [AnyHashable : Any]?, to view: UIView?) {
        var constraints = [AnyHashable]()
        for string: String? in strings as? [String?] ?? [] {
            if let aViews = views as? [String : Any] {
                constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: string ?? "", options: [], metrics: metrics as? [String : Any], views: aViews))
            }
        }
        if let aConstraints = constraints as? [NSLayoutConstraint] {
            view?.addConstraints(aConstraints)
        }
    }

    //* Creates view ready-to-use with auto layout
    class func autolayout() -> Self {
        let view = self.init(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    class func addEdgeConstraint(_ edge: NSLayoutConstraint.Attribute, superview: UIView?, subview: UIView?) {
        if let aSubview = subview {
            superview?.addConstraint(NSLayoutConstraint(item: aSubview, attribute: edge, relatedBy: .equal, toItem: superview, attribute: edge, multiplier: 1, constant: 0))
        }
    }
}