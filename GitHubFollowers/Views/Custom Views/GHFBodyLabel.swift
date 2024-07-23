//
//  GHFBodyLabel.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/20/24.
//

import UIKit

class GHFBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   convenience init(textAlignment: NSTextAlignment) { //use convenience so you don't have to call config func here but make sure you call the self.init
        self.init(frame: .zero)
        self.textAlignment = textAlignment
    }
    
    private func config() {
        textColor                           = .secondaryLabel
        font                                = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory   = true
        adjustsFontSizeToFitWidth           = true
        minimumScaleFactor                  = 0.75
        lineBreakMode                       = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
