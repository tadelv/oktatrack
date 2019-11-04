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
        GHApi.fetchContributionsAsync() { [weak self] contr in

//            _ = self!.objectWillChange.sink(receiveValue: { _ in
//                print("will update: \(contr)")
//            })
            self!.update(contr)

        }
    }

    func update(_ contr: [Contribution]) {
        self.contributors = contr
    }
}
