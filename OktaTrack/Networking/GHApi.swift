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

class GHApi: ObservableObject {
    // TODO: sub
//, Subscriber {
    
    
    static let Input = 0
    static let Failure = 1
    
    // TODO: resumable data?
    fileprivate static let resume_data = Data()

    typealias ContributionsCallback = ([Contribution]) -> Void
    typealias RepositoriesCallback = ([Repository]) -> Void

    @discardableResult
    class func fetchContributionsAsync(repository: Repository, _ callback: @escaping ContributionsCallback) -> [Contribution] {

        let network_task = TaskBuilder(url: repository.contributors_url) { (data, response, error) in
            guard let data = data else {
                print(error!)
                DispatchQueue.main.async {
                    callback([])
                }
                return
            }
            let contribs = SearchResponseParser(jsonData: data).decodeContributors()
            DispatchQueue.main.async {
                callback(contribs)
            }
        }
        network_task.build().resume()

        return []
    }
    
    @discardableResult
    static func fetchRepositoriesAsync(page: UInt, _ callback: @escaping RepositoriesCallback) -> [Contribution] {
        let query = "?q=language:swift&page=\(page)&per_page=25"
        let url = UrlBuilder(path: "/search/repositories").buildUrl(query)
        let network_task = TaskBuilder(url: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    print(error!)
                    callback([])
                }
                return
            }
            let repos = SearchResponseParser(jsonData: data).decodeRepositories()
            DispatchQueue.main.async {
                callback(repos)
            }
        }
        network_task.build().resume()
        return []
    }
}


