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

class MasterCoordinator: ObservableObject {

  @Published var repositories = [Repository]()
  private var page_offset: UInt = 1
  private (set) var page_size = 25

  func requestFresh() {
    let _ = GHApi.fetchRepositoriesAsync(page: page_offset) { (repos) in
      if repos.count == self.page_size {
        self.repositories.append(contentsOf: repos)
        self.page_offset += 1
      }
    }
  }
}
