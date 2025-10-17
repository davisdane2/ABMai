//
//  DashboardWebView.swift
//  Dane
//
//  Created by Dane Davis on 10/10/25.
//

import SwiftUI
import UIKit
import WebKit

struct DashboardWebView: UIViewRepresentable {
    let htmlFileName: String
    @Binding var isActive: Bool
    var injectedData: String? = nil // New: Support for centralized data injection

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        // Enable media playback but respect lifecycle
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        // Add console message handler
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "consoleLog")

        // Inject console capture script
        let consoleScript = WKUserScript(
            source: """
            (function() {
                const originalLog = console.log;
                const originalError = console.error;
                const originalWarn = console.warn;

                console.log = function(...args) {
                    window.webkit.messageHandlers.consoleLog.postMessage({
                        level: 'log',
                        message: args.join(' ')
                    });
                    originalLog.apply(console, args);
                };

                console.error = function(...args) {
                    window.webkit.messageHandlers.consoleLog.postMessage({
                        level: 'error',
                        message: args.join(' ')
                    });
                    originalError.apply(console, args);
                };

                console.warn = function(...args) {
                    window.webkit.messageHandlers.consoleLog.postMessage({
                        level: 'warn',
                        message: args.join(' ')
                    });
                    originalWarn.apply(console, args);
                };
            })();
            """,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        contentController.addUserScript(consoleScript)
        config.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        // Load HTML only once during creation
        context.coordinator.loadHTML(in: webView, fileName: htmlFileName)

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // Handle lifecycle changes without reloading
        if context.coordinator.wasActive != isActive {
            if isActive {
                // Resume: Allow timers and network requests to resume
                context.coordinator.resumeDashboard(webView)
            } else {
                // Pause: Clear all intervals/timeouts to stop API calls
                context.coordinator.pauseDashboard(webView)
            }
            context.coordinator.wasActive = isActive
        }

        // Inject data if provided and webView is loaded
        if let data = injectedData, context.coordinator.hasLoaded {
            context.coordinator.injectData(webView, jsonData: data)
        }

        // Only reload if the file has changed (which it shouldn't during normal navigation)
        if context.coordinator.currentFileName != htmlFileName {
            context.coordinator.loadHTML(in: webView, fileName: htmlFileName)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var currentFileName: String = ""
        var wasActive: Bool = true
        var hasLoaded = false
        private var timerIDs: [Int] = []
        private var lastInjectedData: String?

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "consoleLog",
               let body = message.body as? [String: String],
               let level = body["level"],
               let logMessage = body["message"] {
                let prefix = level == "error" ? "🔴 [JS Error]" : level == "warn" ? "🟡 [JS Warn]" : "🔵 [JS Log]"
                print("\(prefix) \(logMessage)")
            }
        }

        func loadHTML(in webView: WKWebView, fileName: String) {
            // Prevent reloading the same content
            guard fileName != currentFileName || !hasLoaded else {
                print("⏭️ Skipping reload of \(fileName) - already loaded")
                return
            }

            guard let bundlePath = Bundle.main.path(forResource: fileName, ofType: nil) else {
                print("❌ Could not find HTML file: \(fileName)")
                return
            }

            let url = URL(fileURLWithPath: bundlePath)
            let directory = url.deletingLastPathComponent()

            do {
                let htmlContent = try String(contentsOf: url, encoding: .utf8)
                webView.loadHTMLString(htmlContent, baseURL: directory)
                currentFileName = fileName
                print("📄 Loading dashboard: \(fileName)")
            } catch {
                print("❌ Error loading HTML: \(error)")
            }
        }

        func pauseDashboard(_ webView: WKWebView) {
            // JavaScript to pause all timers and intervals
            let pauseScript = """
            (function() {
                // Store original setInterval/setTimeout if not already stored
                if (!window._originalSetInterval) {
                    window._originalSetInterval = window.setInterval;
                    window._originalSetTimeout = window.setTimeout;
                    window._originalClearInterval = window.clearInterval;
                    window._originalClearTimeout = window.clearTimeout;
                    window._activeTimers = [];
                }

                // Clear all active timers
                window._activeTimers.forEach(function(id) {
                    window._originalClearInterval(id);
                    window._originalClearTimeout(id);
                });
                window._activeTimers = [];

                console.log('🛑 Dashboard paused - all timers cleared');
            })();
            """

            webView.evaluateJavaScript(pauseScript) { _, error in
                if let error = error {
                    print("⚠️ Error pausing dashboard: \(error.localizedDescription)")
                } else {
                    print("⏸️ Dashboard timers paused")
                }
            }
        }

        func resumeDashboard(_ webView: WKWebView) {
            // JavaScript to resume - just log, the page will recreate timers naturally
            let resumeScript = """
            (function() {
                console.log('▶️ Dashboard resumed - page can create new timers');

                // Optionally trigger a manual refresh if your dashboards expose a refresh function
                if (typeof window.refreshData === 'function') {
                    window.refreshData();
                }
            })();
            """

            webView.evaluateJavaScript(resumeScript) { _, error in
                if let error = error {
                    print("⚠️ Error resuming dashboard: \(error.localizedDescription)")
                } else {
                    print("▶️ Dashboard resumed")
                }
            }
        }

        /// Inject centralized data into the WebView
        /// This allows dashboards to use pre-fetched data instead of making their own API calls
        func injectData(_ webView: WKWebView, jsonData: String) {
            // Avoid re-injecting the same data
            guard jsonData != lastInjectedData else { return }

            lastInjectedData = jsonData

            // Escape the JSON string for safe JavaScript injection
            let escapedJSON = jsonData
                .replacingOccurrences(of: "\\", with: "\\\\")
                .replacingOccurrences(of: "\"", with: "\\\"")
                .replacingOccurrences(of: "\n", with: "\\n")
                .replacingOccurrences(of: "\r", with: "\\r")

            let injectionScript = """
            (function() {
                try {
                    // Store centralized data in window object
                    window.centralizedDashboardData = JSON.parse("\(escapedJSON)");
                    console.log('✅ Centralized data injected successfully');

                    // Trigger custom event for dashboards to listen to
                    const event = new CustomEvent('dashboardDataUpdated', {
                        detail: window.centralizedDashboardData
                    });
                    window.dispatchEvent(event);

                    // If dashboard has update handler, call it
                    if (typeof window.onDashboardDataUpdate === 'function') {
                        window.onDashboardDataUpdate(window.centralizedDashboardData);
                    }
                } catch (error) {
                    console.error('❌ Failed to inject data:', error);
                }
            })();
            """

            webView.evaluateJavaScript(injectionScript) { _, error in
                if let error = error {
                    print("⚠️ Data injection error: \(error.localizedDescription)")
                } else {
                    print("💉 Data injected into WebView")
                }
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            hasLoaded = true
            print("✅ Web content loaded successfully: \(currentFileName)")

            // Inject timer tracking on page load
            let timerTrackingScript = """
            (function() {
                if (!window._originalSetInterval) {
                    window._originalSetInterval = window.setInterval;
                    window._originalSetTimeout = window.setTimeout;
                    window._activeTimers = [];

                    // Wrap setInterval to track timer IDs
                    window.setInterval = function() {
                        const id = window._originalSetInterval.apply(this, arguments);
                        window._activeTimers.push(id);
                        return id;
                    };

                    // Wrap setTimeout to track timer IDs
                    window.setTimeout = function() {
                        const id = window._originalSetTimeout.apply(this, arguments);
                        window._activeTimers.push(id);
                        return id;
                    };

                    console.log('✅ Timer tracking initialized');
                }
            })();
            """

            webView.evaluateJavaScript(timerTrackingScript) { _, _ in }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("❌ Web content failed to load: \(error.localizedDescription)")
        }

        // Handle JavaScript errors gracefully
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("❌ Provisional navigation failed: \(error.localizedDescription)")
        }
    }
}

struct DashboardDetailView: View {
    let dashboard: Dashboard
    @State private var isActive = true
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var webView: WKWebView?
    @EnvironmentObject var dataManager: DashboardDataManager

    var body: some View {
        VStack(spacing: 0) {
            // "Recently Updated" banner
            if dashboard.showRecentlyUpdatedBadge {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14, weight: .bold))
                    Text("Recently Updated in v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.42")")
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [Color.green.opacity(0.8), Color.blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            }

            // Navigation toolbar
            if canGoBack || canGoForward {
                HStack(spacing: 20) {
                    Button(action: {
                        webView?.goBack()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(canGoBack ? .white : .gray)
                            .frame(width: 44, height: 44)
                    }
                    .disabled(!canGoBack)

                    Button(action: {
                        webView?.goForward()
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(canGoForward ? .white : .gray)
                            .frame(width: 44, height: 44)
                    }
                    .disabled(!canGoForward)

                    Spacer()

                    Button(action: {
                        webView?.reload()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.1, green: 0.1, blue: 0.3),
                            Color(red: 0.0, green: 0.0, blue: 0.25)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.2)),
                    alignment: .bottom
                )
            }

            // WebView
            NavigatableDashboardWebView(
                htmlFileName: dashboard.htmlPath,
                isActive: $isActive,
                canGoBack: $canGoBack,
                canGoForward: $canGoForward,
                webView: $webView,
                injectedData: dataManager.exportAsJSON()
            )
        }
        .navigationTitle(dashboard.name)
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear {
            isActive = true
        }
        .onDisappear {
            isActive = false
        }
    }
}

struct NavigatableDashboardWebView: UIViewRepresentable {
    let htmlFileName: String
    @Binding var isActive: Bool
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    @Binding var webView: WKWebView?
    var injectedData: String? = nil // New: Support for centralized data injection

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        // Add console message handler
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "consoleLog")

        // Inject console capture script
        let consoleScript = WKUserScript(
            source: """
            (function() {
                const originalLog = console.log;
                const originalError = console.error;
                const originalWarn = console.warn;

                console.log = function(...args) {
                    window.webkit.messageHandlers.consoleLog.postMessage({
                        level: 'log',
                        message: args.join(' ')
                    });
                    originalLog.apply(console, args);
                };

                console.error = function(...args) {
                    window.webkit.messageHandlers.consoleLog.postMessage({
                        level: 'error',
                        message: args.join(' ')
                    });
                    originalError.apply(console, args);
                };

                console.warn = function(...args) {
                    window.webkit.messageHandlers.consoleLog.postMessage({
                        level: 'warn',
                        message: args.join(' ')
                    });
                    originalWarn.apply(console, args);
                };
            })();
            """,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        contentController.addUserScript(consoleScript)
        config.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsBackForwardNavigationGestures = true

        context.coordinator.loadHTML(in: webView, fileName: htmlFileName)

        // Store webView reference
        DispatchQueue.main.async {
            self.webView = webView
        }

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // Update navigation state
        DispatchQueue.main.async {
            self.canGoBack = webView.canGoBack
            self.canGoForward = webView.canGoForward
        }

        // Handle lifecycle changes
        if context.coordinator.wasActive != isActive {
            if isActive {
                context.coordinator.resumeDashboard(webView)
            } else {
                context.coordinator.pauseDashboard(webView)
            }
            context.coordinator.wasActive = isActive
        }

        // Inject data if provided and webView is loaded
        if let data = injectedData, context.coordinator.hasLoaded {
            context.coordinator.injectData(webView, jsonData: data)
        }

        if context.coordinator.currentFileName != htmlFileName {
            context.coordinator.loadHTML(in: webView, fileName: htmlFileName)
        }
    }

    func makeCoordinator() -> NavigationCoordinator {
        NavigationCoordinator(canGoBack: $canGoBack, canGoForward: $canGoForward)
    }

    class NavigationCoordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var currentFileName: String = ""
        var wasActive: Bool = true
        var hasLoaded = false
        private var lastInjectedData: String?
        @Binding var canGoBack: Bool
        @Binding var canGoForward: Bool

        init(canGoBack: Binding<Bool>, canGoForward: Binding<Bool>) {
            _canGoBack = canGoBack
            _canGoForward = canGoForward
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "consoleLog",
               let body = message.body as? [String: String],
               let level = body["level"],
               let logMessage = body["message"] {
                let prefix = level == "error" ? "🔴 [JS Error]" : level == "warn" ? "🟡 [JS Warn]" : "🔵 [JS Log]"
                print("\(prefix) \(logMessage)")
            }
        }

        func loadHTML(in webView: WKWebView, fileName: String) {
            guard fileName != currentFileName || !hasLoaded else {
                print("⏭️ Skipping reload of \(fileName) - already loaded")
                return
            }

            guard let bundlePath = Bundle.main.path(forResource: fileName, ofType: nil) else {
                print("❌ Could not find HTML file: \(fileName)")
                return
            }

            let url = URL(fileURLWithPath: bundlePath)
            let directory = url.deletingLastPathComponent()

            do {
                let htmlContent = try String(contentsOf: url, encoding: .utf8)
                webView.loadHTMLString(htmlContent, baseURL: directory)
                currentFileName = fileName
                print("📄 Loading dashboard: \(fileName)")
            } catch {
                print("❌ Error loading HTML: \(error)")
            }
        }

        func pauseDashboard(_ webView: WKWebView) {
            let pauseScript = """
            (function() {
                if (!window._originalSetInterval) {
                    window._originalSetInterval = window.setInterval;
                    window._originalSetTimeout = window.setTimeout;
                    window._originalClearInterval = window.clearInterval;
                    window._originalClearTimeout = window.clearTimeout;
                    window._activeTimers = [];
                }

                window._activeTimers.forEach(function(id) {
                    window._originalClearInterval(id);
                    window._originalClearTimeout(id);
                });
                window._activeTimers = [];

                console.log('🛑 Dashboard paused - all timers cleared');
            })();
            """

            webView.evaluateJavaScript(pauseScript) { _, error in
                if let error = error {
                    print("⚠️ Error pausing dashboard: \(error.localizedDescription)")
                } else {
                    print("⏸️ Dashboard timers paused")
                }
            }
        }

        func resumeDashboard(_ webView: WKWebView) {
            let resumeScript = """
            (function() {
                console.log('▶️ Dashboard resumed - page can create new timers');

                if (typeof window.refreshData === 'function') {
                    window.refreshData();
                }
            })();
            """

            webView.evaluateJavaScript(resumeScript) { _, error in
                if let error = error {
                    print("⚠️ Error resuming dashboard: \(error.localizedDescription)")
                } else {
                    print("▶️ Dashboard resumed")
                }
            }
        }

        /// Inject centralized data into the WebView
        func injectData(_ webView: WKWebView, jsonData: String) {
            guard jsonData != lastInjectedData else { return }
            lastInjectedData = jsonData

            let escapedJSON = jsonData
                .replacingOccurrences(of: "\\", with: "\\\\")
                .replacingOccurrences(of: "\"", with: "\\\"")
                .replacingOccurrences(of: "\n", with: "\\n")
                .replacingOccurrences(of: "\r", with: "\\r")

            let injectionScript = """
            (function() {
                try {
                    window.centralizedDashboardData = JSON.parse("\(escapedJSON)");
                    console.log('✅ Centralized data injected successfully');

                    const event = new CustomEvent('dashboardDataUpdated', {
                        detail: window.centralizedDashboardData
                    });
                    window.dispatchEvent(event);

                    if (typeof window.onDashboardDataUpdate === 'function') {
                        window.onDashboardDataUpdate(window.centralizedDashboardData);
                    }
                } catch (error) {
                    console.error('❌ Failed to inject data:', error);
                }
            })();
            """

            webView.evaluateJavaScript(injectionScript) { _, error in
                if let error = error {
                    print("⚠️ Data injection error: \(error.localizedDescription)")
                } else {
                    print("💉 Data injected into WebView")
                }
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            hasLoaded = true
            print("✅ Web content loaded successfully")

            // Update navigation state
            DispatchQueue.main.async {
                self.canGoBack = webView.canGoBack
                self.canGoForward = webView.canGoForward
            }

            let timerTrackingScript = """
            (function() {
                if (!window._originalSetInterval) {
                    window._originalSetInterval = window.setInterval;
                    window._originalSetTimeout = window.setTimeout;
                    window._activeTimers = [];

                    window.setInterval = function() {
                        const id = window._originalSetInterval.apply(this, arguments);
                        window._activeTimers.push(id);
                        return id;
                    };

                    window.setTimeout = function() {
                        const id = window._originalSetTimeout.apply(this, arguments);
                        window._activeTimers.push(id);
                        return id;
                    };

                    console.log('✅ Timer tracking initialized');
                }
            })();
            """

            webView.evaluateJavaScript(timerTrackingScript) { _, _ in }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("❌ Web content failed to load: \(error.localizedDescription)")
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("❌ Provisional navigation failed: \(error.localizedDescription)")
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Check if this is a navigation to the CHASCO system
            if let url = navigationAction.request.url,
               url.host == "10.52.10.100" {
                // Cancel the navigation in the WebView
                decisionHandler(.cancel)

                // Open in Safari instead
                print("🌐 Opening CHASCO in Safari: \(url.absoluteString)")
                DispatchQueue.main.async {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:]) { success in
                            if success {
                                print("✅ Successfully opened CHASCO in Safari")
                            } else {
                                print("❌ Failed to open CHASCO in Safari")
                            }
                        }
                    }
                }
                return
            }

            // Allow all other navigation
            decisionHandler(.allow)

            // Update navigation state after navigation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.canGoBack = webView.canGoBack
                self.canGoForward = webView.canGoForward
            }
        }
    }
}
