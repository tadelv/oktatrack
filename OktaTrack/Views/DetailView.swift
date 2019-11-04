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
                Text(repository.name).font(.title)
                Text(repository.description).font(.caption).padding(15)
            }
            List {
                Section(header: Text("Contributors")) {
                    ForEach(coordinator.contributors, id: \.id) { contribution in
                        HStack(spacing: 5) {
                            WebImageView().frame(minWidth:20, maxWidth:60, minHeight:40, maxHeight:60)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            Text("\(contribution.login)").font(.headline)
                            Spacer()
                            Text("\(contribution.contributions)")
                        }
                    }
                }
            }
        }.navigationBarTitle(Text(repository.owner.login), displayMode: .inline)
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let repo = SearchResponseParser.mockRepositories()[0]
        let coord = DetailCoordinator(repo)
        return DetailView(repo,coord)
    }
}
