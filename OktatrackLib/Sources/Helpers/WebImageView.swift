//
//  WebImageView.swift
//  OktaTrack
//
//  Created by Vid on 11/1/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import SwiftUI

// TODO: Load images from web
public struct WebImageView: View {
    
    @ObservedObject private var downloader: ImageDownloader
    
    public init(url: URL) {
        downloader = ImageDownloader(url: url)
    }

    public var body: some View {
        Image(uiImage: downloader.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .task {
              await downloader.loadImage()
            }
    }
}

final class ImageDownloader: ObservableObject {
    
    enum State {
        case Waiting
        case Downloading
        case Finished
    }
    
    @Published private(set) var state = State.Waiting
    @Published private(set) var image = UIImage()

  private let url: URL
    
    init(url: URL) {
      self.url = url
    }

  @MainActor
  func loadImage() async {
    state = .Downloading
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      guard let img = UIImage(data: data) else {
        print("bad image data...")
        return
      }
      self.state = .Finished
      self.image = img
    } catch {
      print("Image download failed: \(error)")
      return
    }
  }
    
    
}
