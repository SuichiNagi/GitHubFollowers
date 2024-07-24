//
//  UITableView+Ext.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 7/23/24.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
