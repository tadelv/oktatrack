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

    var body: some View {
        NavigationView {
            MasterView { page in
                try await withCheckedThrowingContinuation { continuation in
                    GHApi.fetchRepositoriesAsync(page: page) { repos in
                        continuation.resume(returning: repos)
                    }
                }
            } detail: { repo in
                DetailView(repo, DetailCoordinator(repo, fetch: {
                    try await withCheckedThrowingContinuation { continuation in
                        GHApi.fetchContributionsAsync(repository: repo) {
                            continuation.resume(with: .success($0))
                        }
                    }
                }))
            }
            .navigationBarTitle(Text("Repositories"), displayMode: .automatic)
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
