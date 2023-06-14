//
//  DetailCoordinator.swift
//  OktaTrack
//
//  Created by Vid on 11/2/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Foundation
import Models
import Observation

@Observable
public final class DetailCoordinator {

    let repository: Repository
    let fetch: () async throws -> [Contribution]
    private(set) var contributors: [Contribution] = []

    public init(_ repository: Repository, fetch: @escaping () async throws -> [Contribution]) {
        self.repository = repository
        self.fetch = fetch
    }

    func fetchContributors() async {
        do {
            self.contributors = try await fetch()
        } catch {
            print("handle error here: \(error)")
        }
    }
}
