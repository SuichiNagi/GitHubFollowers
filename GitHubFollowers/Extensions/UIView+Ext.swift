//
//  UIView+Ext.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 7/23/24.
//

import UIKit


extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
