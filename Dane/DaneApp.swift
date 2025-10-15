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
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    dataManager.handleAppDidBecomeActive()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    dataManager.handleAppWillResignActive()
                }
        }
    }
}
