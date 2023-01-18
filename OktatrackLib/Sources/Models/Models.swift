//
//  Repository.swift
//  OktaTrack
//
//  Created by Vid on 10/28/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Foundation

public struct GHSearchResponseRoot: Decodable {
    public init(items: [Repository], totalCount: UInt) {
        self.items = items
        self.total_count = totalCount
    }
    public let items: [Repository]
    public let total_count: UInt
}

public struct Author: Decodable, Equatable {
    public init(login: String, avatarUrl: URL) {
        self.login = login
        self.avatar_url = avatarUrl
    }

    public let login: String
    public let avatar_url: URL
}

public struct Repository: Decodable, Equatable, Identifiable {
    public init(id: Int,
                name: String,
                full_name: String,
                owner: Author,
                description: String? = nil,
                size: UInt,
                stargazers_count: UInt,
                forks_count: UInt,
                contributors_url: URL,
                watchers: UInt) {
        self.id = id
        self.name = name
        self.full_name = full_name
        self.owner = owner
        self.description = description
        self.size = size
        self.stargazers_count = stargazers_count
        self.forks_count = forks_count
        self.contributors_url = contributors_url
        self.watchers = watchers
    }

    public let id: Int
    public let name: String
    public let full_name: String
    public let owner: Author
    public let description: String?
    public let size: UInt
    public let stargazers_count: UInt
    public let forks_count: UInt
    public let contributors_url: URL
    public let watchers: UInt
}

public struct Contribution: Decodable {
    public init(id: UInt,
                login: String,
                avatarUrl: URL,
                contributions: UInt) {
        self.id = id
        self.login = login
        self.avatar_url = avatarUrl
        self.contributions = contributions
    }

    public let id: UInt
    public let login: String
    public let avatar_url: URL
    public let contributions: UInt
}


public extension Contribution {
  static var mock: [Contribution] {
    [
      .init(id: 1,
            login: "mock user",
            avatarUrl: URL(string: "a")!,
            contributions: 12)
    ]
  }
}
