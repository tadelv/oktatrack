//
//  MasterCoordinator.swift
//  OktaTrack
//
//  Created by Vid on 11/2/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Foundation

class MasterCoordinator {

  var repositories = [Repository]()
  private var page_offset = 0
  private (set) var page_size = 25

  func requestFresh() {
    // TODO: signal view
    repositories = SearchResponseParser.mockRepositories()
    page_offset += 1
  }

}
