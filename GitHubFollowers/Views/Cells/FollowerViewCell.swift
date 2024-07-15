//
//  FollowerViewCell.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/21/24.
//

import UIKit
import SnapKit

class FollowerViewCell: UICollectionViewCell {
    
    static let reuseID = "FollowerViewCell"
    
    let padding: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower: FollowerModel) {
        usernameLabel.text = follower.login
        NetworkManager.shared.downloadImage(from: follower.avatarUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
    }
    
    private func config() {
//        setAutoLayoutConstraints()
        setSnpConstraints()
    }
    
    func setAutoLayoutConstraints() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setSnpConstraints() {
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(padding)
            make.leading.equalTo(self).offset(padding)
            make.trailing.equalTo(self).offset(-padding)
            make.height.equalTo(avatarImageView.snp.width)
        }
        
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(12)
            make.leading.equalTo(self).offset(padding)
            make.trailing.equalTo(self).offset(-padding)
            make.height.equalTo(20)
        }
    }
    
    lazy var avatarImageView: GHFAvatarImageView = {
        let imageView = GHFAvatarImageView(frame: .zero)
        return imageView
    }()
    
    lazy var usernameLabel: GHFTitleLabel = {
        let label = GHFTitleLabel(textAlignment: .center, fontSize: 16)
        return label
    }()
}
