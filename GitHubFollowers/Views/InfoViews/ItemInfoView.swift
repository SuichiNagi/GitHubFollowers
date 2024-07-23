//
//  ItemInfoView.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/27/24.
//

import UIKit

enum ItemInfoType {
    case repos, gists, followers, following
}

class ItemInfoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        addSubviews(symbolImageView, titleLabel, countLabel)
        
//       setAutoLayoutConstraint()
        setSnpConstraints()
    }
    
    func set(itemInfoType: ItemInfoType, withCount count: Int) {
        switch itemInfoType {
        case .repos:
            symbolImageView.image   = IconSymbols.location
            titleLabel.text         = "Public Repos"
            
        case .gists:
            symbolImageView.image   = IconSymbols.gists
            titleLabel.text         = "Public Gists"
            
        case .followers:
            symbolImageView.image   = IconSymbols.followers
            titleLabel.text         = "Followers"
            
        case .following:
            symbolImageView.image   = IconSymbols.repos
            titleLabel.text         = "Following"
        }
        
        countLabel.text         = String(count)
    }
    
    private func setAutoLayoutConstraint() {
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func setSnpConstraints() {
        symbolImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(self)
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(symbolImageView)
            make.leading.equalTo(symbolImageView.snp.trailing).offset(12)
            make.trailing.equalTo(self)
            make.height.equalTo(18)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(symbolImageView.snp.bottom).offset(4)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(18)
        }
    }

    lazy var symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode   = .scaleAspectFill
        imageView.tintColor     = .label
        return imageView
    }()
    
    lazy var titleLabel: GHFTitleLabel = {
        let title = GHFTitleLabel(textAlignment: .left, fontSize: 14)
        return title
    }()
    
    lazy var countLabel: GHFTitleLabel = {
        let title = GHFTitleLabel(textAlignment: .center, fontSize: 14)
        return title
    }()
}
