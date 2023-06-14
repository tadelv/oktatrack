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
  struct PreferenceKey: SwiftUI.PreferenceKey {
    static var defaultValue: CGPoint { .zero }

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
      value = nextValue()
    }
  }
  
  var repository: Repository
  private let coordinator: DetailCoordinator
  @State var position: CGPoint = .zero

  private let coordinateSpaceName = UUID()
  
  public init(_ repository: Repository, _ coordinator: DetailCoordinator) {
    self.repository = repository
    self.coordinator = coordinator
  }

  public var body: some View {
    ScrollView {
      LazyVStack {
        RepoStatsView(repository: repository, position: position.y)
          .background(GeometryReader { geometry in
            Color.clear.preference(
              key: PreferenceKey.self,
              value: geometry.frame(in: .named(coordinateSpaceName)).origin
            )
          })
          .onPreferenceChange(PreferenceKey.self) { position in
            self.position = position
          }

        HStack {
          Text("Contributors")
            .font(.headline)
          Spacer()
        }
        .padding([.leading, .trailing, .top])
        ForEach(coordinator.contributors, id: \.id) { contribution in
          ContributorView(contribution: contribution)
            .padding([.leading, .trailing])
        }
      }
    }
    .coordinateSpace(name: coordinateSpaceName)
    .navigationTitle(repository.name)
    .task {
      await coordinator.fetchContributors()
    }
  }
}

struct RepoStatsView: View {
  let repository: Repository
  let position: Double

  var body: some View {
    VStack(spacing: spacing) {
      HStack {
        Text("by " + repository.owner.login)
          .font(.headline)
        Spacer()
      }
        .padding([.leading, .trailing])
      Text(repository.description ?? "")
        .font(.subheadline)
        .padding([.leading, .trailing])
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
    .opacity(opacity)
  }

  var spacing: Double {
    guard position > 0 else {
      return 8
    }
    return 8 + position * 0.5
  }

  var opacity: Double {
    return 1.0 * ((50 + position) / 50)
  }
}

struct ContributorView: View {
  let contribution: Contribution
  var body: some View {
    HStack {
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


struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      DetailView(.mock,
                 DetailCoordinator(.mock, fetch: { Contribution.mock }))
    }
  }
}
