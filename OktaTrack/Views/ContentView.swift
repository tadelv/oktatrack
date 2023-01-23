//
//  ContentView.swift
//  OktaTrack
//
//  Created by Vid on 10/28/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import DetailFeature
import MasterFeature
import Models
import SwiftUI

struct ContentView: View {

  let api: APIClient

  var body: some View {
    NavigationView {
      MasterView { page, perPage in
        try await api.fetchRepositories(page, perPage)
      } detail: { repo in
        DetailView(repo, DetailCoordinator(repo, fetch: {
          try await api.fetchContributions(repo.contributors_url)
        }))
      }
      .navigationBarTitle(Text("Repositories"), displayMode: .automatic)
      .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(api: APIClient { _, _ in
      [
        .init(id: 1,
              name: "Preview repo",
              full_name: "Preview repo description",
              owner: .init(login: "Preview user", avatarUrl: .mock),
              size: 200,
              stargazers_count: 10,
              forks_count: 12,
              contributors_url: .mock,
              watchers: 23)
      ]
    } fetchContributions: { _ in
      Contribution.mock
    })
  }
}
