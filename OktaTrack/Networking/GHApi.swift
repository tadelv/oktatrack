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

    class func fetchContributionsAsync(_ callback: @escaping ContributionsCallback) -> [Contribution] {
        
        let url = UrlBuilder(path: "/repos/CosmicMind/Material/contributors").buildUrl("?page=1")
        let network_task = TaskBuilder(url: url) { (data, response, error) in
            print("\(data ?? Data()),\(String(describing: response)),\(String(describing: error))")
            guard let data = data else {
                callback(SearchResponseParser.mockContributors())
                return
            }
            let contribs = SearchResponseParser(jsonData: data).decodeContributors()
            callback(contribs)
        }
        network_task.build().resume()

        return SearchResponseParser.mockContributors()
    }
}

struct UrlBuilder {
    
    static let host = "https://api.github.com"
    
    let path: String
    
    func buildUrl(_ urlString: String) -> URL {
        let url_s = UrlBuilder.host + urlString
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
            print(fields)
        }
        return TaskBuilder.session.dataTask(with: url_req, completionHandler: completion)
    }
    
}
