//
//  ContentView.swift
//  OktaTrack
//
//  Created by Vid on 10/28/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            MasterView()
                .navigationBarTitle(Text("Repositories"), displayMode: .automatic)
                .navigationViewStyle(DoubleColumnNavigationViewStyle())
//                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

//    TODO: fix detail view appearing on iPad
//    possibly a bug in SwiftUI on iPad vertical orientation
//    if repositories.count > 0 {
//        DetailView(selectedRepository: repositories[0])
//    }
//}.navigationViewStyle(StackNavigationViewStyle())
struct MasterView: View {

    @ObservedObject private var coordinator = MasterCoordinator()
    private let offset: Int = 10
    
    init() {
        coordinator.requestFresh()
    }

    var body: some View {
        List {
            ForEach(coordinator.repositories, id: \.self) { repo in
                NavigationLink(destination: DetailView(repo,DetailCoordinator(repo))) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(repo.full_name)").font(.headline)
                        Text("\(repo.name)").font(.subheadline)
                    }.padding(5)
                        .onAppear {
                            self.listItemAppears(repo)
                    }
                }
                .shadow(radius: 2)
                .accentColor(Color.pureColor(val: 0x333))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// pagination
extension RandomAccessCollection where Self.Element: Identifiable {
    func isThresholdItem<Item: Identifiable>(offset: Int,
                                             item: Item) -> Bool {
        guard !isEmpty else {
            return false
        }

        guard let itemIndex = firstIndex(where: { AnyHashable($0.id) == AnyHashable(item.id) }) else {
            return false
        }

        let distance = self.distance(from: itemIndex, to: endIndex)
        let offset = offset < count ? offset : count - 1
        return offset == (distance - 1)
    }
}

extension MasterView {
    private func listItemAppears<Item: Identifiable>(_ item: Item) {
        if coordinator.repositories.isThresholdItem(offset: offset, item: item) {
            coordinator.requestFresh()
        }
    }
}
