//
//  DetailCoordinator.swift
//  OktaTrack
//
//  Created by Vid on 11/2/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Foundation

class DetailCoordinator: ObservableObject {

    let repository: Repository
    @Published var contributors: [Contribution] = []

    init(_ repository: Repository) {
        self.repository = repository
    }

    func fetchContributors() {
        let _ = GHApi.fetchContributionsAsync(repository: repository) { [weak self] contr in
            self!.contributors = contr
        }
    }
}
