//
//  UserInfoHeaderView.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/26/24.
//

import UIKit

class UserInfoHeaderView: UIView {
    
    let padding: CGFloat            = 20
    let textImagePadding: CGFloat   = 12
    
    var user: UserModel!
    
    init(user: UserModel) {
        super.init(frame: .zero)
        self.user = user
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        addSubviews(avatarImageView, usernameLabel, nameLabel, locationImageView, locationLabel, bioLabel)
        
//        setAutoLayoutConstraints()
        setSnpConstraints()
    }
    
    func setAutoLayoutConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setSnpConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(padding)
            make.leading.equalTo(self)
            make.width.height.equalTo(90)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(textImagePadding)
            make.trailing.equalTo(self)
            make.height.equalTo(38)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView).offset(8)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(textImagePadding)
            make.trailing.equalTo(self)
            make.height.equalTo(20)
        }
        
        locationImageView.snp.makeConstraints { make in
            make.bottom.equalTo(avatarImageView)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(textImagePadding)
            make.width.height.equalTo(20)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationImageView)
            make.leading.equalTo(locationImageView.snp.trailing).offset(5)
            make.trailing.equalTo(self)
            make.height.equalTo(20)
        }
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(textImagePadding)
            make.leading.equalTo(avatarImageView)
            make.trailing.equalTo(self)
            make.height.equalTo(60)
        }
    }
    
    lazy var avatarImageView: GHFAvatarImageView = {
        let imageView = GHFAvatarImageView(frame: .zero)
        imageView.downloadImage(fromURL: user.avatarUrl)
        return imageView
    }()
    
    lazy var usernameLabel: GHFTitleLabel = {
        let titleLabel  = GHFTitleLabel(textAlignment: .left, fontSize: 34)
        titleLabel.text = user.login
        return titleLabel
    }()
    
    lazy var nameLabel: GHFSecondaryTitleLabel = {
        let secondaryLabel  = GHFSecondaryTitleLabel(fontSize: 18)
        secondaryLabel.text = user.name ?? ""
        return secondaryLabel
    }()
    
    lazy var locationImageView: UIImageView = {
        let imageView       = UIImageView()
        imageView.image     = IconSymbols.location
        imageView.tintColor = .secondaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var locationLabel: GHFSecondaryTitleLabel = {
        let secondaryLabel  = GHFSecondaryTitleLabel(fontSize: 18)
        secondaryLabel.text = user.location ?? "No location"
        return secondaryLabel
    }()
    
    lazy var bioLabel: GHFBodyLabel = {
        let bodyLabel   = GHFBodyLabel(textAlignment: .left)
        bodyLabel.text  = user.bio ?? "No bio available"
        return bodyLabel
    }()
}
