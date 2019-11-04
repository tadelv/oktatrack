//
//  Repository.swift
//  OktaTrack
//
//  Created by Vid on 10/28/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Foundation

struct GHSearchResponseRoot: Decodable {
    let items: [Repository]
    let total_count: UInt
    
}

struct Repository: Decodable, Equatable, Hashable {
    
    let name: String
    let full_name: String
    let owner: Author
    let description: String
    let size: UInt
    let stargazers_count: UInt
    let forks_count: UInt
    let contributors_url: URL
    let watchers: UInt
    
    struct Author: Decodable {
        let login: String
        let avatar_url: URL
    }
    
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.name == rhs.name && lhs.owner.login == rhs.owner.login
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(owner.login)
    }
}
