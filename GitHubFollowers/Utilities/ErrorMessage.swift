//
//  ErrorMessage.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/21/24.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidUsername    = "This username created an invalid request. Please try again"
    case unableToComplete   = "Unable to complete your request. Please check you internet connection"
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server is invalid. Please try again"
    case unableToFavorite   = "There was an error adding this user to favorites. Please try again"
    case alreadyInFavorites = "Already in favorites."
}
