//
//  Contribution.swift
//  OktaTrack
//
//  Created by Vid on 10/28/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Foundation

struct Contribution: Decodable {
    let id: UInt
    let login: String
    let avatar_url: URL
    let contributions: UInt
}
