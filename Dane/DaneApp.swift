//
//  DaneApp.swift
//  Dane
//
//  Created by Dane Davis on 10/10/25.
//

import SwiftUI

@main
struct DaneApp: App {
    // Central data manager - single source of truth
    @StateObject private var dataManager = DashboardDataManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .onAppear {
                    // Start background refresh when app launches
                    dataManager.startBackgroundRefresh()

                    #if targetEnvironment(macCatalyst)
                    // Set larger window size for Mac (2x scale)
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        windowScene.sizeRestrictions?.minimumSize = CGSize(width: 800, height: 1200)
                        windowScene.sizeRestrictions?.maximumSize = CGSize(width: 1600, height: 2400)
                    }
                    #endif
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    dataManager.handleAppDidBecomeActive()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    dataManager.handleAppWillResignActive()
                }
        }
        #if targetEnvironment(macCatalyst)
        .defaultSize(width: 1000, height: 1600)
        #endif
    }
}
