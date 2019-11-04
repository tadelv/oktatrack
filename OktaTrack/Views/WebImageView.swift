//
//  WebImageView.swift
//  OktaTrack
//
//  Created by Vid on 11/1/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import SwiftUI

// TODO: Load images from web
struct WebImageView: View {
    
    @ObservedObject private var downloader: ImageDownloader
    
    init(url: URL) {
        downloader = ImageDownloader(url: url)
    }

    var body: some View {
//        Color(.blue)
        Image(uiImage: downloader.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
}

class ImageDownloader: ObservableObject {
    
    enum State {
        case Waiting
        case Downloading
        case Finished
    }
    
    @Published private(set) var state = State.Waiting
    @Published private(set) var image = UIImage()
    
    init(url: URL) {
        let task = TaskBuilder(url: url) { (data, response, error) in
            DispatchQueue.main.async {
                self.state = .Finished
            }
            guard let data = data else {
                return
            }
            guard let img = UIImage(data: data) else {
                print("bad image data...")
                return
            }
            DispatchQueue.main.async {
                self.image = img
            }
        }
        state = .Downloading
        task.build().resume()
    }
    
    
}
