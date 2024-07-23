//
//  FavoriteViewCell.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 7/1/24.
//

import UIKit

class FavoriteViewCell: UITableViewCell {
    
    let padding: CGFloat = 12
    
    static let reuseID = "FavoriteViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        addSubviews(avatarImageView, usernameLabel)

        accessoryType = .disclosureIndicator
        
//        setAutoLayoutConstraints()
        setSnpConstraints()
    }
    
    func set(favorite: FollowerModel) {
        NetworkManager.shared.downloadImage(from: favorite.avatarUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async() {
                self.avatarImageView.image = image
            }
        }
        usernameLabel.text = favorite.login
    }
    
    private func setAutoLayoutConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setSnpConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(padding)
            make.height.width.equalTo(60)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(24)
            make.trailing.equalTo(self).offset(-padding)
            make.height.equalTo(40)
        }
    }
    
    lazy var avatarImageView: GHFAvatarImageView = {
        let imageView = GHFAvatarImageView(frame: .zero)
        return imageView
    }()
    
    lazy var usernameLabel: GHFTitleLabel = {
        let titleLabel = GHFTitleLabel(textAlignment: .left, fontSize: 26)
        return titleLabel
    }()
}
