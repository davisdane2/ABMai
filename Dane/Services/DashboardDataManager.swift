//
//  DashboardDataManager.swift
//  Dane
//
//  Created by Dane Davis on 10/14/25.
//  Centralized data management with background refresh
//  Cross-platform architecture (iOS → Android migration ready)
//

import Foundation
import Combine

/// Central hub for all dashboard data
/// Fetches data once, distributes to all dashboards
/// This pattern translates directly to Android's ViewModel + StateFlow
@MainActor
class DashboardDataManager: ObservableObject {

    // MARK: - Published Properties (Observable State)
    // These will become StateFlow in Android

    @Published var dataSnapshot: DashboardDataSnapshot?
    @Published var isLoading: Bool = false
    @Published var lastRefreshDate: Date?
    @Published var error: SupabaseError?

    // Individual data streams for specific dashboards
    @Published var chameleonInventory: [ChameleonInventory] = []
    @Published var admixInventory: [AdmixInventory] = []
    @Published var concreteDemand: [ConcreteDemand] = []
    @Published var asphaltDemand: [AsphaltDemand] = []
    @Published var rawMaterialDemands: [RawMaterialDemand] = []
    @Published var powderDemand: [PowderDemand] = []
    @Published var driverSchedule: [DriverSchedule] = []
    @Published var acContent: [ACContent] = []
    @Published var acIncomingOrders: [ACIncomingOrder] = []

    // MARK: - Configuration
    private let refreshInterval: TimeInterval = 500 // Long Interval for Refreshes as these are only updated every few hours
    private let client: SupabaseClient
    private var refreshTimer: Timer?
    private var isBackgroundRefreshEnabled = false

    // MARK: - Initialization

    init() {
        self.client = SupabaseClient.shared
        print("📊 DashboardDataManager initialized")
    }

    // Dependency injection initializer for testing
    init(client: SupabaseClient) {
        self.client = client
        print("📊 DashboardDataManager initialized (with custom client)")
    }

    // MARK: - Public API

    /// Start automatic background refresh
    /// Call this when app becomes active
    func startBackgroundRefresh() {
        guard !isBackgroundRefreshEnabled else {
            print("⚠️ Background refresh already enabled")
            return
        }

        isBackgroundRefreshEnabled = true
        print("▶️ Starting background refresh (interval: \(refreshInterval)s)")

        // Initial fetch
        Task {
            await fetchAllData()
        }

        // Setup timer for periodic refresh
        refreshTimer = Timer.scheduledTimer(
            withTimeInterval: refreshInterval,
            repeats: true
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.fetchAllData(silent: true)
            }
        }
    }

    /// Stop background refresh
    /// Call this when app goes to background
    func stopBackgroundRefresh() {
        guard isBackgroundRefreshEnabled else { return }

        isBackgroundRefreshEnabled = false
        refreshTimer?.invalidate()
        refreshTimer = nil
        print("⏸️ Stopped background refresh")
    }

    /// Manual refresh (user-triggered)
    func refresh() async {
        await fetchAllData(silent: false)
    }

    // MARK: - Data Fetching

    /// Fetch all dashboard data in one parallel batch
    private func fetchAllData(silent: Bool = false) async {
        if !silent {
            isLoading = true
        }

        // Parallel fetch all endpoints
        let snapshot = await client.fetchAllDashboardData()

        // Update published properties
        self.dataSnapshot = snapshot
        self.lastRefreshDate = Date()
        self.error = nil

        // Update individual arrays
        if let chameleon = snapshot.chameleonInventory {
            self.chameleonInventory = chameleon
        }
        if let admix = snapshot.admixInventory {
            self.admixInventory = admix
        }
        if let concrete = snapshot.concreteDemand {
            self.concreteDemand = concrete
        }
        if let asphalt = snapshot.asphaltDemand {
            self.asphaltDemand = asphalt
        }
        if let rawMaterials = snapshot.rawMaterialDemands {
            self.rawMaterialDemands = rawMaterials
        }
        if let powder = snapshot.powderDemand {
            self.powderDemand = powder
        }
        if let schedule = snapshot.driverSchedule {
            self.driverSchedule = schedule
        }
        if let acContent = snapshot.acContent {
            self.acContent = acContent
        }
        if let acOrders = snapshot.acIncomingOrders {
            self.acIncomingOrders = acOrders
        }

        // Cache to UserDefaults for offline access
        cacheSnapshot(snapshot)

        // Check if we have any data, otherwise load cached
        if snapshot.chameleonInventory == nil &&
           snapshot.admixInventory == nil &&
           snapshot.concreteDemand == nil &&
           snapshot.asphaltDemand == nil &&
           snapshot.rawMaterialDemands == nil &&
           snapshot.powderDemand == nil &&
           snapshot.driverSchedule == nil &&
           snapshot.acContent == nil &&
           snapshot.acIncomingOrders == nil {
            print("⚠️ No data fetched, loading cached data")
            loadCachedData()
        } else if !silent {
            print("✅ Data refresh complete - \(snapshot.fetchedAt.formatted())")
        }

        if !silent {
            isLoading = false
        }
    }

    // MARK: - Caching (Offline Support)

    private func cacheSnapshot(_ snapshot: DashboardDataSnapshot) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(snapshot)
            UserDefaults.standard.set(data, forKey: "cached_dashboard_snapshot")
            print("💾 Data cached successfully")
        } catch {
            print("⚠️ Failed to cache data: \(error.localizedDescription)")
        }
    }

    private func loadCachedData() {
        guard let data = UserDefaults.standard.data(forKey: "cached_dashboard_snapshot") else {
            print("ℹ️ No cached data available")
            return
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let snapshot = try decoder.decode(DashboardDataSnapshot.self, from: data)

            // Update UI with cached data
            self.dataSnapshot = snapshot
            if let chameleon = snapshot.chameleonInventory {
                self.chameleonInventory = chameleon
            }
            if let admix = snapshot.admixInventory {
                self.admixInventory = admix
            }
            if let concrete = snapshot.concreteDemand {
                self.concreteDemand = concrete
            }
            if let asphalt = snapshot.asphaltDemand {
                self.asphaltDemand = asphalt
            }
            if let rawMaterials = snapshot.rawMaterialDemands {
                self.rawMaterialDemands = rawMaterials
            }
            if let powder = snapshot.powderDemand {
                self.powderDemand = powder
            }
            if let schedule = snapshot.driverSchedule {
                self.driverSchedule = schedule
            }
            if let acContent = snapshot.acContent {
                self.acContent = acContent
            }
            if let acOrders = snapshot.acIncomingOrders {
                self.acIncomingOrders = acOrders
            }

            print("📦 Loaded cached data from \(snapshot.fetchedAt.formatted())")
        } catch {
            print("⚠️ Failed to load cached data: \(error.localizedDescription)")
        }
    }

    // MARK: - Data Export for WebViews

    /// Export data as JSON string for WebView injection
    func exportAsJSON() -> String? {
        guard let snapshot = dataSnapshot else { return nil }

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(snapshot)
            return String(data: data, encoding: .utf8)
        } catch {
            print("⚠️ Failed to export JSON: \(error.localizedDescription)")
            return nil
        }
    }

    /// Export specific dashboard data
    func exportChameleonJSON() -> String? {
        return encodeToJSON(chameleonInventory)
    }

    func exportAdmixJSON() -> String? {
        return encodeToJSON(admixInventory)
    }

    func exportConcreteJSON() -> String? {
        return encodeToJSON(concreteDemand)
    }

    func exportRawMaterialDemandsJSON() -> String? {
        return encodeToJSON(rawMaterialDemands)
    }

    func exportAsphaltDemandJSON() -> String? {
        return encodeToJSON(asphaltDemand)
    }

    func exportDriverScheduleJSON() -> String? {
        return encodeToJSON(driverSchedule)
    }

    func exportPowderDemandJSON() -> String? {
        return encodeToJSON(powderDemand)
    }

    func exportACContentJSON() -> String? {
        return encodeToJSON(acContent)
    }

    func exportACIncomingOrdersJSON() -> String? {
        return encodeToJSON(acIncomingOrders)
    }

    private func encodeToJSON<T: Encodable>(_ data: T) -> String? {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(data)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("⚠️ JSON encoding failed: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Lifecycle Management

    deinit {
        // Timer cleanup doesn't need main actor isolation
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
}

// MARK: - App Lifecycle Extension
extension DashboardDataManager {
    /// Call when app enters foreground
    func handleAppDidBecomeActive() {
        print("🌟 App became active - resuming data refresh")
        startBackgroundRefresh()
    }

    /// Call when app enters background
    func handleAppWillResignActive() {
        print("💤 App will resign active - pausing data refresh")
        stopBackgroundRefresh()
    }
}
