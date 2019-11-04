//
//  GHApi.swift
//  OktaTrack
//
//  Created by Vid on 10/28/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Foundation
import Combine

class GHApi: ObservableObject {
    // TODO: sub
//, Subscriber {
    
    
    static let Input = 0
    static let Failure = 1
    
    // TODO: resumable data?
    fileprivate static let resume_data = Data()

    typealias ContributionsCallback = ([Contribution]) -> Void
    typealias RepositoriesCallback = ([Repository]) -> Void

    class func fetchContributionsAsync(repository: Repository, _ callback: @escaping ContributionsCallback) -> [Contribution] {

        let network_task = TaskBuilder(url: repository.contributors_url) { (data, response, error) in
            print("\(data ?? Data()),\(String(describing: response)),\(String(describing: error))")
            guard let data = data else {
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

    static func fetchRepositoriesAsync(page: UInt, _ callback: @escaping RepositoriesCallback) -> [Contribution] {
        let query = "?q=language:swift&page=\(page)&per_page=25"
        let url = UrlBuilder(path: "/search/repositories").buildUrl(query)
        let network_task = TaskBuilder(url: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
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

struct UrlBuilder {
    
    static let host = "https://api.github.com"
    
    let path: String
    
    func buildUrl(_ urlString: String = "") -> URL {
        let url_s = UrlBuilder.host + path + urlString
        // TODO: wrap around a try catch?
        return URL(string: url_s)!
    }
}

struct TaskBuilder {
    
    let url: URL
    typealias Completion = (Data?, URLResponse?, Error?) -> Void
    let completion: Completion
    
    static let session = URLSession(configuration: .default)
    
    func build() -> URLSessionTask {
        //        let networkTask = URLSession(configuration: .default).downloadTask(with: url_req)
        //        let networkTask = URLSession(configuration: .default).dataTaskPublisher(for: url_req)
        //        networkTask.receive(subscriber: self)
        //        networkTask.resume()
        
        var url_req = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10.0)
        url_req.mainDocumentURL = url
        url_req.allowsExpensiveNetworkAccess = false
        url_req.allHTTPHeaderFields.map { fields in
//            print(fields)
        }
        return TaskBuilder.session.dataTask(with: url_req, completionHandler: completion)
    }
    
}
