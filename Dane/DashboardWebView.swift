//
//  DashboardWebView.swift
//  Dane
//
//  Created by Dane Davis on 10/10/25.
//

import SwiftUI
import WebKit

struct DashboardWebView: UIViewRepresentable {
    let htmlFileName: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        loadHTML(in: webView)
    }

    private func loadHTML(in webView: WKWebView) {
        guard let bundlePath = Bundle.main.path(forResource: htmlFileName, ofType: nil) else {
            print("❌ Could not find HTML file: \(htmlFileName)")
            return
        }

        let url = URL(fileURLWithPath: bundlePath)
        let directory = url.deletingLastPathComponent()

        do {
            let htmlContent = try String(contentsOf: url, encoding: .utf8)
            webView.loadHTMLString(htmlContent, baseURL: directory)
        } catch {
            print("❌ Error loading HTML: \(error)")
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("✅ Web content loaded successfully")
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("❌ Web content failed to load: \(error.localizedDescription)")
        }
    }
}

struct DashboardDetailView: View {
    let dashboard: Dashboard

    var body: some View {
        DashboardWebView(htmlFileName: dashboard.htmlPath)
            .navigationTitle(dashboard.name)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(.all, edges: .bottom)
    }
}
