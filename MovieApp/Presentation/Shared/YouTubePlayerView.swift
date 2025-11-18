//
//  YouTubePlayerView.swift
//  MovieApp
//
//  Created by Sahithi.Mucchala on 17/11/25.
//

//  Purpose:
//  A reusable SwiftUI wrapper around WKWebView intended to play YouTube trailers
//  inline within the movie detail screen using the video key returned by TMDB.
//
//  This approach was explored because TMDB provides only YouTube video IDs,
//  meaning native playback using AVPlayer is not possible without a direct
//  streaming URL(MP4). Using a WebView allows embedding YouTube via
//  the standard iframe method and keeps the user inside the app.
//
//  Notes:
//  - videos are failing to play or showing restrictions (e.g., YouTube Error 153)
//    depending on content licensing, embed permissions, or age restrictions.
//  - This component is kept intentionally in the project to demonstrate alternate
//    solution attempts and technical evaluation before finalizing playback UX.
//
//  Status:
//  Not currently used in flow, but ready for reconsideration or enhancement 

import SwiftUI
import WebKit

struct YouTubePlayerView: UIViewRepresentable {
    let videoKey: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .black
        webView.isOpaque = false
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let urlString = "https://www.youtube.com/embed/\(videoKey)?playsinline=1"
        guard let url = URL(string: urlString) else { return }

        if webView.url != url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

