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

class UserInfoVC: UIViewController {
    
    let padding: CGFloat = 20
    let itemHeight: CGFloat = 140
    
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
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                self.userModel = user
            } catch {
                if let errorMessage = error as? ErrorMessage {
                    presentGHFAlert(title: "Something went wrong", message: errorMessage.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
            }
        }
    }
    
    func setUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        itemViews = [userInfoHeaderView, itemViewOne, itemViewTwo, dateLabel]
        
//        setAutoLayoutConstraint()
        setSnpConstraint()
    }
    
    func setAutoLayoutConstraint() {
        scrollView.pinToEdgesAutoLayout(of: view)
        contentView.pinToEdgesAutoLayout(of: scrollView)
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        }
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600),
            
            userInfoHeaderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            userInfoHeaderView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: userInfoHeaderView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func setSnpConstraint() {
        scrollView.pinToEdgesSnp(of: view)
        contentView.pinToEdgesAutoLayout(of: scrollView)
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.height.equalTo(600)
        }
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            itemView.snp.makeConstraints { make in
                make.leading.equalTo(contentView).offset(padding)
                make.trailing.equalTo(contentView).offset(-padding)
            }
        }
        
        userInfoHeaderView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
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

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    lazy var userInfoHeaderView: UserInfoHeaderView = {
        let userInfoHead = UserInfoHeaderView(user: userModel!)
        return userInfoHead
    }()
    
    lazy var itemViewOne: RepoItemView = {
        let view        = RepoItemView(user: userModel!, delegate: self)
        return view
    }()
    
    lazy var itemViewTwo: FollowerItemView = {
        let view        = FollowerItemView(user: userModel!, delegate: self)
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
            presentGHFAlert(title: "No followers", message: "This user has no followers.", buttonTitle: "Ok")
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
            presentGHFAlert(title: "Invalid URL", message: "url attached is invalid.", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
}
