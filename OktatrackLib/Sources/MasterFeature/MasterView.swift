//
//  File.swift
//  
//
//  Created by Vid Tadel on 1/17/23.
//

import Models
import SwiftUI

public struct MasterView<Detail: View>: View {

    @ObservedObject private var coordinator: MasterCoordinator
    private let offset: Int = 10

    private let detailLink: (Repository) -> Detail

    public init(fetch: @escaping (UInt) async throws -> [Repository],
                detail: @escaping (Repository) -> Detail) {
        self.detailLink = detail
        _coordinator = ObservedObject(wrappedValue: MasterCoordinator(fetch))
        coordinator.requestFresh()
    }

    public var body: some View {
        List {
            ForEach(coordinator.repositories) { repo in
                NavigationLink {
                    detailLink(repo)
                } label: {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(repo.full_name)").font(.headline)
                    Text("\(repo.name)").font(.subheadline)
                }.padding(5)
                    .onAppear {
                        self.listItemAppears(repo)
                    }
            }
            }
        }
    }
}

extension MasterView {
    private func listItemAppears<Item: Identifiable>(_ item: Item) {
        if coordinator.repositories.isThresholdItem(offset: offset, item: item) {
            coordinator.requestFresh()
        }
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

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MasterView { page in
                var results: [Repository] = []
                let pageId = page * 25
                for i in 1...25 {
                    results.append(Repository(id: Int(pageId) + i,
                                              name: "repo \(i + Int(pageId))",
                                              full_name: "Test repo",
                                              owner: .init(login: "test", avatarUrl: URL(string: "a")!),
                                              size: 200,
                                              stargazers_count: 200,
                                              forks_count: 200,
                                              contributors_url: URL(string: "a")!,
                                              watchers: 200))
                }
                return results
            } detail: { repo in
                Text("Detail for \(repo.name)")
            }
        }
    }
}
