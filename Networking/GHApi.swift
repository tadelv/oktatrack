//
//  GHApi.swift
//  OktaTrack
//
//  Created by Vid on 10/28/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Foundation

class GHApi: ObservableObject {
    
    // access token: 950785990113f33ca766dcc3d178bb48026eb136

//    func fetchRepositories() -> [Repository?] {
//        return []
//    }
    @Published var token = "950785990113f33ca766dcc3d178bb48026eb136"

    typealias ContributionsCallback = ([Contribution]) -> Void

    class func fetchContributionsAsync(_ callback: ContributionsCallback) {
        let contribs = SearchResponseParser.mockContributors()
        callback(contribs)
    }
}
