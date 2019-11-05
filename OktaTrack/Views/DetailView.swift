//
//  DetailView.swift
//  OktaTrack
//
//  Created by Vid on 11/2/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import SwiftUI

struct DetailView: View {

    var repository: Repository
    @ObservedObject private var coordinator: DetailCoordinator

    init(_ repository: Repository, _ coordinator: DetailCoordinator) {
        self.repository = repository
        self.coordinator = coordinator
    }

    var body: some View {
        VStack {
            Section {
                Spacer().frame(width: 1, height: 15, alignment: .center)
                Text("By " + repository.owner.login)
                    .font(.headline)
                    .foregroundColor(Color.pureColor(val: 0xbd2c00ff))
                    .scaledToFit()
                Text(repository.description)
                    .font(.subheadline)
                    .foregroundColor(Color.pureColor(val: 0x333333ff))
                    .padding(15)

                HStack {
                    Spacer()
                    VStack {
                        Text("⋔:").font(.headline)
                        Text("\(repository.forks_count)")
                    }
                    .padding(10)
                    .foregroundColor(Color.pureColor(val: 0x6cc64477))
                    Spacer()
                    VStack {
                        Text("✨:").font(.headline)
                        Text("\(repository.stargazers_count)")
                    }
                    .padding(10)
                    .foregroundColor(Color.pureColor(val: 0xc9510c77))
                    Spacer()
                    VStack {
                        Text("🚛").font(.headline)
                        Text("\(String(format:"%.2f",(Double(repository.size))/1024.0))kB")
                    }
                    .padding(10)
                    .foregroundColor(Color.pureColor(val: 0x6e549477))
                    Spacer()
                }
            }
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
            .onAppear() {
                self.coordinator.fetchContributors()
            }
        }
        .navigationBarTitle(Text(repository.name), displayMode: .inline)
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let repo = SearchResponseParser.mockRepositories()[0]
        let coord = DetailCoordinator(repo)
        return DetailView(repo,coord)
    }
}
