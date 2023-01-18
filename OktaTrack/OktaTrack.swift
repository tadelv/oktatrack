//
//  OktaTrack.swift
//  OktaTrack
//
//  Created by Vid Tadel on 1/18/23.
//  Copyright © 2023 Delta96. All rights reserved.
//

import SwiftUI

@main
struct OktaTrack: App {
  var body: some Scene {
    WindowGroup {
      ContentView(api: APIClient())
    }
  }
}
