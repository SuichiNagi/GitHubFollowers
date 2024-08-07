//
//  FollowerItemView.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/28/24.
//

import UIKit

protocol FollowerItemViewDelegate: AnyObject {
    func didTapGetFollowers(for user: UserModel)
}

class FollowerItemView: ItemInfoContentView {
    
    weak var delegate: FollowerItemViewDelegate!
    
    var user: UserModel!
    
    init(user: UserModel, delegate: FollowerItemViewDelegate) {
        super.init(frame: .zero)
        self.user = user
        self.delegate = delegate
        
        configItems()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(color: .systemGreen, title: "Get Followers", systemImageName: "person")
    }
    
    override func actionButtonTapped() {
//        delegate.didTapGetFollowers()
        delegate.didTapGetFollowers(for: user)
    }

}
