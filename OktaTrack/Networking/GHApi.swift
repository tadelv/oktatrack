//
//  GHApi.swift
//  OktaTrack
//
//  Created by Vid on 10/28/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Combine
import Foundation
import Helpers
import Models

struct APIClient {
  var fetchRepositories: (UInt, UInt) async throws -> [Repository] = { page, perPage in
    let query = "?q=language:swift&page=\(page)&per_page=25"
    let url = UrlBuilder(path: "/search/repositories").buildUrl(query)
    let data = try await AsyncTaskBuilder(url: url).fetch()
    let response = try JSONDecoder().decode(GHSearchResponseRoot.self, from: data)
    return response.items
  }

  var fetchContributions: (URL) async throws -> [Contribution] = { url in
    let data = try await AsyncTaskBuilder(url: url).fetch()
    return try JSONDecoder().decode([Contribution].self, from: data)
  }
}
