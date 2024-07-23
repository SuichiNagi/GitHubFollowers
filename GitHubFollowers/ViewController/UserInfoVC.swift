//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/26/24.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class UserInfoVC: UIViewController/*, UserInfoVCDelegate*/ {
    
    weak var delegate: UserInfoVCDelegate!
    
    var itemViews: [UIView] = []
    
    var username: String!
    
    var userModel: UserModel! {
        didSet { /*This ensures setUI() is called only after userModel is initialized.*/
            DispatchQueue.main.async {
                self.setUI()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configVC()
        getUserInfo()
    }
    
    func configVC() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                self.userModel = user
            case .failure(let error):
                self.presentGHFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                break
            }
        }
    }
    
    //MARK: Delegate
//    func didTapGitHubProfile() {
//        //Show Safari View Controller
//        guard let url = URL(string: userModel.htmlUrl) else {
//            presentGHFAlertOnMainThread(title: "Invalid URL", message: "url attached is invalid.", buttonTitle: "Ok")
//            return
//        }
//        
//        let safariVC = SFSafariViewController(url: url)
//        safariVC.preferredControlTintColor = .systemGreen
//        present(safariVC, animated: true)
//    }
//    
//    func didTapGetFollowers() {
//        //dismissVC
//        //Tell follower list screen the new user
//    }
    
    func setUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [userInfoHeaderView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
//            NSLayoutConstraint.activate([
//                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
//                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
//            ])
            
            itemView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(padding)
                make.trailing.equalToSuperview().offset(-padding)
            }
        }
        
//        NSLayoutConstraint.activate([
//            userInfoHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            userInfoHeaderView.heightAnchor.constraint(equalToConstant: 180),
//            
//            itemViewOne.topAnchor.constraint(equalTo: userInfoHeaderView.bottomAnchor, constant: padding),
//            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
//            
//            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
//            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
//            
//            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
//            dateLabel.heightAnchor.constraint(equalToConstant: 18)
//        ])
    
        userInfoHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(180)
        }
        
        itemViewOne.snp.makeConstraints { make in
            make.top.equalTo(userInfoHeaderView.snp.bottom).offset(padding)
            make.height.equalTo(itemHeight)
        }
        
        itemViewTwo.snp.makeConstraints { make in
            make.top.equalTo(itemViewOne.snp.bottom).offset(padding)
            make.height.equalTo(itemHeight)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(itemViewTwo.snp.bottom).offset(padding)
            make.height.equalTo(18)
        }
    }

    
    lazy var userInfoHeaderView: UserInfoHeaderView = {
        let userInfoHead = UserInfoHeaderView(user: userModel!)
        return userInfoHead
    }()
    
    lazy var itemViewOne: RepoItemView = {
        let view        = RepoItemView(user: userModel!)
        view.delegate   = self
        return view
    }()
    
    lazy var itemViewTwo: FollowerItemView = {
        let view        = FollowerItemView(user: userModel!)
        view.delegate   = self
        return view
    }()
    
    lazy var dateLabel: GHFBodyLabel = {
        let dateLabel   = GHFBodyLabel(textAlignment: .center)
        dateLabel.text  = "GitHub since \(userModel.createdAt.convertToMonthYearFormat())"
//        dateLabel.text  = "GitHub since \(userModel.createdAt.convertToDisplayFormat())"
        return dateLabel
    }()
}

extension UserInfoVC: FollowerItemViewDelegate {
    func didTapGetFollowers(for user: UserModel) {
        guard user.followers != 0 else {
            presentGHFAlertOnMainThread(title: "No followers", message: "This user has no followers.", buttonTitle: "Ok")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
}

extension UserInfoVC: RepoItemViewDelegate {
    func didTapGitHubProfile(for user: UserModel) {
        //Show Safari View Controller
        guard let url = URL(string: userModel.htmlUrl) else {
            presentGHFAlertOnMainThread(title: "Invalid URL", message: "url attached is invalid.", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
}
