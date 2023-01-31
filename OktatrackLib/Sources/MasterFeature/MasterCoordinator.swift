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

@MainActor
public class MasterCoordinator: ObservableObject {

    @Published var repositories = [Repository]()
    private var page_offset: UInt = 0
    private (set) var page_size: UInt = 25

    private let fetch: (UInt, UInt) async throws -> [Repository]

    public init(_ fetch: @escaping (UInt, UInt) async throws -> [Repository]) {
        self.fetch = fetch
    }

    func requestFresh() async {
        do {
            let repos = try await fetch(page_offset, page_size)
            self.repositories.append(contentsOf: repos.filter {
                !self.repositories.contains($0)
            })
            if repos.count >= self.page_size {
                self.page_offset += 1
            }
        } catch {
            print("Unhandled error: \(error)")
        }
    }
}
