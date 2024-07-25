//
//  FollowerListVC.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/20/24.
//

import UIKit

class FollowerListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var username: String!
    var followers: [FollowerModel]          = []
    var filteredFollowers: [FollowerModel]  = []
    var page                                = 1
    var hasMoreFollowers                    = true
    var isSearching                         = false
    var isLoadingMoreFollowers              = false

    var dataSource: UICollectionViewDiffableDataSource<Section, FollowerModel>!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username   = username
        self.title      = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFollowers(username: username, page: page)
        setUI()
        configDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setUI() {
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToFave))
        navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(configCollectionView)
    }
    
    lazy var configSearchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater   = self
        searchController.searchBar.placeholder  = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = true
        return searchController
    }()
     
    lazy var configCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerViewCell.self, forCellWithReuseIdentifier: FollowerViewCell.reuseID)
        collectionView.delegate = self
        return collectionView
    }()
    
    func updateUI(with followers: [FollowerModel]) {
        //If followers count is less than 100 it will the hasMoreFollowers to false
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        
        //If there's no follower it will show the emptyStateView
        if self.followers.isEmpty {
            DispatchQueue.main.async {
                self.showEmptyStateView(with: "This user doesn't have any followers.", in: self.view)
                return
            }
        }
        
        //if has followers show the search bar
        DispatchQueue.main.async {
            self.navigationItem.searchController = self.configSearchController
        }
        
        self.updateData(on: self.followers)
    }
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
            
                self.updateUI(with: followers)
            case .failure(let error):
                self.presentGHFAlertOnMainThread(title: "Oh No! There's an error", message: error.rawValue, buttonTitle: "Ok")
                
            }
            
            self.isLoadingMoreFollowers = false
        }
    }
    
    func configDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, FollowerModel>(collectionView: configCollectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerViewCell.reuseID, for: indexPath) as! FollowerViewCell
            
            cell.set(follower: follower)
            
            return cell
        })
    }
    
    func updateData(on followers: [FollowerModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FollowerModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func addUserToFavorites(user: UserModel) {
        let favorite = FollowerModel(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                self.presentGHFAlertOnMainThread(title: "Success", message: "Successfully added to the favorite lists", buttonTitle: "Ok")
                return
            }
            self.presentGHFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    @objc func addToFave() {
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                self.addUserToFavorites(user: user)
            case .failure(let error):
                self.presentGHFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray     = isSearching ? filteredFollowers : followers
        let follower        = activeArray[indexPath.item]
        
        let userInfoVC      = UserInfoVC()
        userInfoVC.username = follower.login
        userInfoVC.delegate = self
        
        let navUserInfoVC   = UINavigationController(rootViewController: userInfoVC)
        present(navUserInfoVC, animated: true)
    }
}

extension FollowerListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            isSearching = false
            updateData(on: followers)
            return
        }
        
        isSearching = true
        filteredFollowers = followers.filter({ $0.login.lowercased().contains(filter.lowercased()) })
        updateData(on: filteredFollowers)
    }
}

extension FollowerListVC: UserInfoVCDelegate {
    
    func didRequestFollowers(for username: String) {
        self.username   = username
        title           = username
        page            = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        configCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}

