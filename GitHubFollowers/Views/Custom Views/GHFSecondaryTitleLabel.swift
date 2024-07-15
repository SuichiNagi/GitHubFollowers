//
//  GHFSecondaryTitleLabel.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/26/24.
//

import UIKit

class GHFSecondaryTitleLabel: GHFBodyLabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    private func config() {
        minimumScaleFactor  = 0.90
        lineBreakMode       = .byTruncatingTail
    }
}
