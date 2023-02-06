//
//  File.swift
//  
//
//  Created by Vid Tadel on 1/17/23.
//

import Helpers
import Models
import SwiftUI

public struct MasterView<Detail: View>: View {

  @ObservedObject private var coordinator: MasterCoordinator
  @State private var selectedRepo: Repository?

  private let offset: Int = 5

  @ViewBuilder
  private var detailLink: (Repository) -> Detail

  public init(fetch: @escaping (UInt, UInt) async throws -> [Repository],
              detail: @escaping (Repository) -> Detail) {
    self.detailLink = detail
    _coordinator = ObservedObject(wrappedValue: MasterCoordinator(fetch))
  }

  public var body: some View {
    NavigationStack {
      List {
        ForEach(coordinator.repositories) { repo in
          HStack {
            VStack(alignment: .leading, spacing: 5) {
              Text("\(repo.name)").font(.headline)
              Text("\(repo.full_name)").font(.subheadline)
            }
            Spacer()
          }
          .contentShape(Rectangle())
          .padding(5)
          .onAppear {
            self.listItemAppeared(repo)
          }
          .onTapGesture {
            self.selectedRepo = repo
          }
        }
      }
      .navigateIfEquatableValue($selectedRepo) { repo in
        detailLink(repo)
      }
      .navigationTitle("Repositories")
    }
    .task {
      await coordinator.requestFresh()
    }
  }
}

extension MasterView {
  private func listItemAppeared(_ item: Repository) {
    if coordinator.repositories.isThresholdItem(offset: offset, item: item) {
      Task {
        await coordinator.requestFresh()
      }
    }
  }
}

// pagination
extension RandomAccessCollection where Self.Element: Identifiable {
    func isThresholdItem<Item>(offset: Int,
                               item: Item) -> Bool where Item == Self.Element {
        guard !isEmpty else {
            return false
        }

        guard let itemIndex = firstIndex(where: { $0.id == item.id }) else {
            return false
        }

        let distance = self.distance(from: itemIndex, to: endIndex)
        let offset = offset < count ? offset : count - 1
        return offset == (distance - 1)
    }
}

struct MasterView_Previews: PreviewProvider {
  static var previews: some View {
    MasterView { page, pageSize in
      var results: [Repository] = []
      let pageId = page * pageSize
      for i in 1...Int(pageSize) {
        results.append(Repository(id: Int(pageId) + i,
                                  name: "repo \(i + Int(pageId))",
                                  full_name: "Test repo",
                                  owner: .mock,
                                  size: 200,
                                  stargazers_count: 200,
                                  forks_count: 200,
                                  contributors_url: .mock,
                                  watchers: 200))
      }
      return results
    } detail: { repo in
      Text("Detail for \(repo.name)")
    }
  }
}
