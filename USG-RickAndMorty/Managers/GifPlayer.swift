//
//  GifPlayer.swift
//  USG-RickAndMorty
//
//  Created by Fatih Acıroğlu on 24.04.2023.
//

import Foundation
import SwiftUI
import WebKit

struct GifPlayer: UIViewRepresentable {
    let gifName: String
    let webView: WKWebView

    init(gifName: String) {
        self.gifName = gifName
        let configuration = WKWebViewConfiguration()
        let userController = WKUserContentController()
        let userScript = WKUserScript(source: "document.getElementById('gif').addEventListener('load', function() { this.setAttribute('src', this.src); }, {once: true});", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userController.addUserScript(userScript)
        configuration.userContentController = userController
        webView = WKWebView(frame: .zero, configuration: configuration)
    }

    func makeUIView(context: Context) -> WKWebView {
        guard let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif") else { return WKWebView() }
        let url = URL(fileURLWithPath: gifPath)
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
