//
//  UIView+Ext.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 7/23/24.
//

import UIKit


extension UIView {
    
    func pinToEdgesAutoLayout(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    func pinToEdgesSnp(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(superview)
        }
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
