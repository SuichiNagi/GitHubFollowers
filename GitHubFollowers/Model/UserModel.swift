//
//  UserModel.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/21/24.
//

import Foundation

struct UserModel: Codable {
    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let followers: Int
    let following: Int
    let createdAt: Date
}
