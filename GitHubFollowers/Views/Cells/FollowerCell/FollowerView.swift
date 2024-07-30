//
//  FollowerView.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 7/30/24.
//

import SwiftUI

struct FollowerView: View {
    
    var follower: FollowerModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: follower.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(.avatarPlaceholder)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .clipShape(Circle())
            
            Text(follower.login)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
    }
}

#Preview {
    FollowerView(follower: FollowerModel(login: "SuichiNagi", avatarUrl: ""))
}
