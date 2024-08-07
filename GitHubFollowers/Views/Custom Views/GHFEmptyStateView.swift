//
//  GHFEmptyStateView.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/25/24.
//

import UIKit

class GHFEmptyStateView: UIView {
    
    let labelCenterYConstant: CGFloat   = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -80 : -150
    let logoBottomConstant: CGFloat     = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 80 : 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    private func config() {
        addSubviews(messageLabel, logoImageView)
        
//        setAutoLayoutConstraint()
        setSnpConstraints()
    }
    
    private func setAutoLayoutConstraint() {
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterYConstant),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
            logoImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: logoBottomConstant)
        ])
    }
    
    private func setSnpConstraints() {
        messageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self).offset(labelCenterYConstant)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
            make.height.equalTo(200)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width).multipliedBy(1.3)
            make.height.equalTo(self.snp.width).multipliedBy(1.3)
            make.trailing.equalTo(self).offset(200)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(logoBottomConstant)
        }
    }
    
    lazy var messageLabel: GHFTitleLabel = {
        let label = GHFTitleLabel(textAlignment: .center, fontSize: 28)
        label.numberOfLines  = 3
        label.textColor      = .secondaryLabel
        return label
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView       = UIImageView()
        imageView.image     = Images.emptyStateLogo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
}
