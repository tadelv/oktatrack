//
//  File.swift
//  
//
//  Created by Vid Tadel on 1/16/23.
//

import Foundation

public extension URL {
  static var mock: URL {
    Self(string: "a")!
  }
}

public struct UrlBuilder {
    static let host = "https://api.github.com"

    let path: String

    public init(path: String) {
        self.path = path
    }

    public func buildUrl(_ urlString: String = "") -> URL {
        let url_s = UrlBuilder.host + path + urlString
        // TODO: wrap around a try catch?
        return URL(string: url_s)!
    }
}

public struct TaskBuilder {
    public typealias Completion = (Data?, URLResponse?, Error?) -> Void

    static let session = URLSession(configuration: .default)

    let url: URL
    let completion: Completion

    public init(url: URL, completion: @escaping TaskBuilder.Completion) {
        self.url = url
        self.completion = completion
    }

    public func build() -> URLSessionTask {
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

public struct AsyncTaskBuilder {
  enum BuilderError: LocalizedError {
    case invalidResponse
    case forbidden(String)

    var errorDescription: String? {
      switch self {
      case .invalidResponse:
        return "Invalid response"
      case let .forbidden(message):
        return message
      }
    }
  }
  let url: URL

  public init(url: URL) {
    self.url = url
  }

  public func fetch() async throws -> Data {
    var url_req = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10.0)
    url_req.mainDocumentURL = url
    url_req.allowsExpensiveNetworkAccess = false

    let (data, response) = try await TaskBuilder.session.data(for: url_req)
    guard let urlResponse = response as? HTTPURLResponse else {
      throw BuilderError.invalidResponse
    }
    guard urlResponse.statusCode == 200 else {
      throw BuilderError.forbidden("Status code: \(urlResponse.statusCode)")
    }
    return data
  }
}
