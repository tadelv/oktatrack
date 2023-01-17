//
//  MasterCoordinator.swift
//  OktaTrack
//
//  Created by Vid on 11/2/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Foundation
import Combine
import Models

public class MasterCoordinator: ObservableObject {

    @Published var repositories = [Repository]()
    private var page_offset: UInt = 1
    private (set) var page_size = 25

    private let fetch: (UInt) async throws -> [Repository]

    public init(_ fetch: @escaping (UInt) async throws -> [Repository]) {
        self.fetch = fetch
    }

    func requestFresh() {
        Task {
            do {
                let repos = try await fetch(page_offset)
                await MainActor.run { [weak self] in
                    guard let self else {
                        return
                    }
                    self.repositories.append(contentsOf: repos)
                    if repos.count == self.page_size {
                        self.page_offset += 1
                    }
                }
            } catch {
                print("Unhandled error: \(error)")
            }
        }
    }
}
