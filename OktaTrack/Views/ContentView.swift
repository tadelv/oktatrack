//
//  ContentView.swift
//  OktaTrack
//
//  Created by Vid on 10/28/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var repositories = SearchResponseParser.mockRepositories()

    var body: some View {
        NavigationView {
            MasterView(repositories: $repositories)
                .navigationBarTitle(Text("Repositories"))
//            TODO: fix detail view appearing on iPad
//            possibly a bug in SwiftUI on iPad vertical orientation
//            if repositories.count > 0 {
//                DetailView(selectedRepository: repositories[0])
//            }
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
//        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MasterView: View {

    @Binding var repositories: [Repository]

    var body: some View {
        List {
            ForEach(repositories, id: \.name) { repo in
                NavigationLink(
                    destination: DetailView(repo,DetailCoordinator(repo))
                ) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(repo.full_name)").font(.headline)
                        Text("\(repo.name)").font(.subheadline)
                    }.padding(5)
                }
            }.listStyle(GroupedListStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
