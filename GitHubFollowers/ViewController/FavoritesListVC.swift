//
//  FavoritesListVC.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/20/24.
//

import UIKit

class FavoritesListVC: UIViewController {
    
    var favorites: [FollowerModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFave()
    }
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if favorites.isEmpty {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "star")
            config.text = "No Favorites"
            config.secondaryText = "Add a favorite on the follower list screen"
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    func updateUI(with favorites: [FollowerModel]) {
//        if favorites.isEmpty {
//            self.showEmptyStateView(with: "No Favorites", in: self.view)
//        } else {
//            self.favorites = favorites
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                self.view.bringSubviewToFront(self.tableView)
//            }
//        }
        
        self.favorites = favorites
        setNeedsUpdateContentUnavailableConfiguration()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
    
    func getFave() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let favorites):
                self.updateUI(with: favorites)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentGHFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                }
            }
        }
    }
    
    func setUI() {
        view.backgroundColor    = .systemBackground
        title                   = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
    }
    
    lazy var tableView: UITableView = {
        let tableView           = UITableView()
        tableView.frame         = view.bounds
        tableView.rowHeight     = 80
        tableView.delegate      = self
        tableView.dataSource    = self
//        tableView.removeExcessCells()
        tableView.register(FavoriteViewCell.self, forCellReuseIdentifier: FavoriteViewCell.reuseID)
        return tableView
    }()
    
}

extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteViewCell.reuseID) as! FavoriteViewCell
        
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite    = favorites[indexPath.row]
        let destVC      = FollowerListVC(username: favorite.login)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self else { return }
            
            guard let error else {
                self.favorites.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
                setNeedsUpdateContentUnavailableConfiguration()
//                if favorites.isEmpty {
//                    self.showEmptyStateView(with: "No Favorites", in: self.view)
//                }
                return
            }
            DispatchQueue.main.async {
                self.presentGHFAlert(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}
