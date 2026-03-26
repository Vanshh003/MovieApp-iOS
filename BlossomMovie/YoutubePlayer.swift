//
//  YoutubePlayer.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 10/03/26.
//

import SwiftUI
import WebKit

struct YoutubePlayer: UIViewRepresentable {
    let webView = WKWebView()
    let videoId: String
    let youtubeBaseURL = APIConfig.shared?.youtubeBaseURL
    
    func makeUIView(context: Context) -> some UIView {
        webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let baseURLString = youtubeBaseURL,
              let baseURL = URL(string: baseURLString) else { return }
        
        let fullURL = baseURL.appending(path: videoId)
        
        webView.load(URLRequest(url: fullURL))
    }
}

// 'UIViewRepresentable' lets us wrap a UI kit view and use it inside swiftui
// 'makeUIView()' this function is part of the UIViewRepresentable protocol. its called once the swiftui view is created and tells swiftui that this is a ui kit i want you to use (in this case, show the web view made)
// 'updateUIView()', also part of UIViewRepresentable protocol. this gets called whenever swiftui updates the view (video will be loaded here onto the web view

//
//
//import SwiftUI
//import WebKit
//
//struct YoutubePlayer: UIViewRepresentable {
//    let videoId: String
//
//    func makeCoordinator() -> Coordinator { Coordinator() }
//
//    func makeUIView(context: Context) -> WKWebView {
//        let config = WKWebViewConfiguration()
//        config.allowsInlineMediaPlayback = true
//        if #available(iOS 10.0, *) {
//            config.mediaTypesRequiringUserActionForPlayback = []
//        }
//
//        let webView = WKWebView(frame: .zero, configuration: config)
//        webView.navigationDelegate = context.coordinator
//        webView.scrollView.isScrollEnabled = false
//        webView.isOpaque = false
//        webView.backgroundColor = .black
//        return webView
//    }
//
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        guard !videoId.isEmpty else { return }
//
//        // Prefer canonical embed host or privacy-enhanced mode:
//        // https://www.youtube.com/embed/
//        // https://www.youtube-nocookie.com/embed/
//        
//        let embedBase = "https://www.youtube.com/embed/"  // or youtube-nocookie
//        let src = "\(embedBase)\(videoId)?playsinline=1"
//
//        let html = """
//        <!doctype html>
//        <html>
//        <head>
//        <meta name="viewport" content="width=device-width, initial-scale=1.0">
//        <meta name="referrer" content="strict-origin-when-cross-origin">
//        <style>
//        html, body { margin:0; padding:0; height:100%; background:#000; }
//        iframe { width:100%; height:100%; border:0; }
//        </style>
//        </head>
//        <body>
//        <iframe
//          src="\(src)"
//          title="YouTube video player"
//          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
//          allowfullscreen
//          referrerpolicy="strict-origin-when-cross-origin">
//        </iframe>
//        </body>
//        </html>
//        """
//
//
//
//        // Load only once per videoId (prevents constant reloads)
//        if context.coordinator.lastLoadedVideoId != videoId {
//            context.coordinator.lastLoadedVideoId = videoId
//            webView.loadHTMLString(html, baseURL: URL(string: "https://www.youtube.com"))
//        }
//    }
//
//    final class Coordinator: NSObject, WKNavigationDelegate {
//        var lastLoadedVideoId: String?
//
//        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//            print("❌ didFailProvisionalNavigation:", error.localizedDescription)
//            print("   error:", error)
//        }
//
//        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//            print("❌ didFailNavigation:", error.localizedDescription)
//            print("   error:", error)
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            print("✅ YouTube iframe finished loading")
//        }
//    }
//}
