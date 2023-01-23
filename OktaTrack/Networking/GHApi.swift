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
        let query = "?q=language:swift&page=\(page)&per_page=\(perPage)"
        let url = UrlBuilder(path: "/search/repositories").buildUrl(query)
        let response: GHSearchResponseRoot = try await fetchResponse(AsyncTaskBuilder(url: url))
        return response.items
    }

    var fetchContributions: (URL) async throws -> [Contribution] = { url in
        try await fetchResponse(AsyncTaskBuilder(url: url))
    }
}


func fetchResponse<Response: Decodable>(_ builder: AsyncTaskBuilder) async throws -> Response {
    let data = try await builder.fetch()
    return try JSONDecoder().decode(Response.self, from: data)
}
