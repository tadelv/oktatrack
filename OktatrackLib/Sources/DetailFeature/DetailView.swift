//
//  DetailView.swift
//  OktaTrack
//
//  Created by Vid on 11/2/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Models
import Helpers
import SwiftUI

public struct DetailView: View {

    var repository: Repository
    @ObservedObject private var coordinator: DetailCoordinator

    public init(_ repository: Repository, _ coordinator: DetailCoordinator) {
        self.repository = repository
        self.coordinator = coordinator
    }

    public var body: some View {
        VStack {
            Section {
                Text(repository.name + " by " + repository.owner.login)
                    .font(.headline)
                    .scaledToFit()
                Text(repository.description ?? "")
                    .font(.subheadline)

                HStack {
                    Spacer()
                    VStack {
                        Text("🍴").font(.headline)
                        Text("\(repository.forks_count)")
                    }
                    Spacer()
                    VStack {
                        Text("✨").font(.headline)
                        Text("\(repository.stargazers_count)")
                    }
                    Spacer()
                    VStack {
                        Text("🚛").font(.headline)
                        Text("\(String(format:"%.2f",(Double(repository.size))/1024.0))kB")
                    }
                    Spacer()
                }
            }
            .padding(.top, 15)
            List {
                Section(header: Text("Contributors")) {
                    ForEach(coordinator.contributors, id: \.id) { contribution in
                        HStack(spacing: 5) {
                            WebImageView(url: contribution.avatar_url)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            Text("\(contribution.login)")
                                .font(.headline)
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("🔨")
                                Text("\(contribution.contributions)")
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            coordinator.fetchContributors()
        }
        .navigationBarTitle(Text(repository.name), displayMode: .inline)
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let repo = Repository(id: 1,
                              name: "Test Repo",
                              full_name: "Test repository 123",
                              owner: .init(login: "test user", avatarUrl: URL(string: "a")!),
                              description: "A test repository for preview purposes",
                              size: 300,
                              stargazers_count: 2,
                              forks_count: 12,
                              contributors_url: URL(string: "https://www.google.com")!,
                              watchers: 200)
        let coord = DetailCoordinator(repo, fetch: { [
            .init(id: 1,
                  login: "test",
                  avatarUrl: URL(string: "a")!,
                  contributions: 11),
            .init(id: 1,
                  login: "test",
                  avatarUrl: URL(string: "a")!,
                  contributions: 11),
            .init(id: 1,
                  login: "test",
                  avatarUrl: URL(string: "a")!,
                  contributions: 11),
            .init(id: 1,
                  login: "test",
                  avatarUrl: URL(string: "a")!,
                  contributions: 11),
        ] })
        return DetailView(repo,coord)
    }
}
