//
//  RepoItemView.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/28/24.
//

import UIKit

protocol RepoItemViewDelegate: AnyObject {
    func didTapGitHubProfile(for user: UserModel)
}

class RepoItemView: ItemInfoContentView {
    
    weak var delegate: RepoItemViewDelegate!
    
    var user: UserModel!
    
    init(user: UserModel, delegate: RepoItemViewDelegate) {
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
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(color: .systemPurple, title: "GitHub Profile", systemImageName: "person")
    }
    
    override func actionButtonTapped() {
//        delegate.didTapGitHubProfile()
        delegate.didTapGitHubProfile(for: user)
    }
}
