//
//  SearchResponseParser.swift
//  OktaTrack
//
//  Created by Vid Tadel on 31/10/2019.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Foundation
import Models

// TODO: Use Generics to parse data and return appropriate types if possible
struct SearchResponseParser {
    
    public let jsonData: Data
    
    func decodeRepositories() -> [Repository] {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(GHSearchResponseRoot.self, from: self.jsonData)
            return response.items
        } catch {
            print("Failed to decode json data: \(error)")
        }
        return []
    }
    
    func decodeContributors() -> [Contribution] {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode([Contribution].self, from: self.jsonData)
            return response
        } catch {
            print("Failed to decode json data: \(error)")
        }
        return []
    }
}

//#if DEBUG
// TODO: remove this debug
extension SearchResponseParser {
    
    static func mockRepositories() -> [Repository] {
        let data = self.retrieveJSONFor(type: .SearchItems)!
        return SearchResponseParser(jsonData: data).decodeRepositories()
    }
    
    static func mockContributors() -> [Contribution] {
        let data = self.retrieveJSONFor(type: .Contributors)!
        return SearchResponseParser(jsonData: data).decodeContributors()
    }
    
    enum SampleType {
        case SearchItems
        case Contributors
    }
    
    private static func retrieveJSONFor(type: SampleType) -> Data? {
        var resName = ""
        switch type {
        case .SearchItems:
            resName = "swift_repos_sample"
        case .Contributors:
            resName = "swift_contributors_sample"
        }

        guard let path = Bundle.main.path(forResource: resName, ofType: "json") else {
            return nil
        }
        
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        }
        catch {
            print("Could not load \(resName) json: \(error)")
        }
        return nil
    }
}
//#endif
