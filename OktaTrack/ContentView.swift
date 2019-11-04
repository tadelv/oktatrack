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
                .navigationBarTitle(Text("Results"))
//            DetailView()
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @Binding var repositories: [Repository]

    var body: some View {
        List {
            ForEach(repositories, id: \.name) { repo in
                NavigationLink(
                    destination: DetailView(selectedRepository: repo)
                ) {
                    Text("\(repo.name)")
                    Text("\(repo.owner.login)")
                }
            }
        }
    }
}

struct DetailView: View {
    var selectedRepository: Repository
//    @State private var contributors = SearchResponseParser.mockContributors()

    var body: some View {
        VStack {
            Text(selectedRepository.name).font(.title)
            Text(selectedRepository.description).font(.caption)
//            else {
            Text("Default text")
            Spacer()
//            }
        }.navigationBarTitle(Text(selectedRepository.owner.login))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
