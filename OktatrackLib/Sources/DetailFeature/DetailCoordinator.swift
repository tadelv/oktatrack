//
//  DetailCoordinator.swift
//  OktaTrack
//
//  Created by Vid on 11/2/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Foundation
import Models

public final class DetailCoordinator: ObservableObject {

    let repository: Repository
    let fetch: () async throws -> [Contribution]
    @Published var contributors: [Contribution] = []

    private var runningTask: Task<Void, Never>?

    public init(_ repository: Repository, fetch: @escaping () async throws -> [Contribution]) {
        self.repository = repository
        self.fetch = fetch
    }

    func fetchContributors() {
        runningTask = Task { [weak self] in
            do {
                let contributions = try await fetch()
                await MainActor.run { [weak self] in
                    self?.contributors = contributions
                }
            } catch {
                print("handle error here: \(error)")
            }
        }
    }
}
