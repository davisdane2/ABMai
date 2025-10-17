//
//  Dashboard.swift
//  Dane
//
//  Created by Dane Davis on 10/10/25.
//

import Foundation

struct Dashboard: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let htmlPath: String
    let category: DashboardCategory
    let recentlyUpdatedInVersion: String? // Version when dashboard was updated (e.g., "1.42")

    // Helper to check if "Recently Updated" badge should show
    var showRecentlyUpdatedBadge: Bool {
        guard let updateVersion = recentlyUpdatedInVersion,
              let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false
        }
        // Show badge if update version matches current version
        return updateVersion == currentVersion
    }
}

enum DashboardCategory: String, CaseIterable {
    case inventory = "Inventory"
    case demand = "Product Demand Dashboards"
    case operations = "Schedule & DF"
    case ai = "AI Tools + ChatBot Links"
    case control = "CHASCOmobile"
}

extension Dashboard {
    static let allDashboards = [
        // Inventory Dashboards
        Dashboard(
            name: "Chameleon Inventory",
            description: "Chameleon Inventory for BW & Pit",
            icon: "🦎",
            htmlPath: "chameleon.html",
            category: .inventory,
            recentlyUpdatedInVersion: nil
        ),
        Dashboard(
            name: "Admix Inventory",
            description: "Admixture (Dry Goods) Inventory for Bw & Pit",
            icon: "cemexlogo.png",
            htmlPath: "Admix.html",
            category: .inventory,
            recentlyUpdatedInVersion: nil
        ),
        Dashboard(
            name: "Inventory Submission",
            description: "Update Inventories For BW & Pit + RAP area",
            icon: "deister.png",
            htmlPath: "InventorySubmission.html",
            category: .inventory,
            recentlyUpdatedInVersion: nil
        ),

        // Weekly Demand Dashboards
        Dashboard(
            name: "All Raw Material Demands",
            description: "Combined Raw Material Demands",
            icon: "rawmatlogo.png",
            htmlPath: "RawWeeklyComb.html",
            category: .demand,
            recentlyUpdatedInVersion: "1.50"
        ),
        Dashboard(
            name: "Concrete Demand",
            description: "Weekly Concrete Demand",
            icon: "coneco.png",
            htmlPath: "ConcWeekly.html",
            category: .demand,
            recentlyUpdatedInVersion: "1.50"
        ),
        Dashboard(
            name: "Asphalt Demand",
            description: "Weekly Asphalt Demand",
            icon: "astelogo.png",
            htmlPath: "AsphaltWeekly.html",
            category: .demand,
            recentlyUpdatedInVersion: "1.50"
        ),
        Dashboard(
            name: "AC Oil Demand",
            description: "Weekly AC OIL Demand",
            icon: "acoillogo.png",
            htmlPath: "ACoilWeekly.html",
            category: .demand,
            recentlyUpdatedInVersion: "1.50"
        ),
        Dashboard(
            name: "Powder Demand",
            description: "Weekly Cement/Slag/Flyash Demand",
            icon: "cementlogo.png",
            htmlPath: "PowderWeekly.html",
            category: .demand,
            recentlyUpdatedInVersion: "1.50"
        ),
       

        // Operations
        Dashboard(
            name: "Driver Schedule",
            description: "Driver Start Times & Schedule",
            icon: "dflogo.png",
            htmlPath: "ScheduleDash.html",
            category: .operations,
            recentlyUpdatedInVersion: "1.42"
        ),

        // AI Tools
        Dashboard(
            name: "Concrete Quote AI",
            description: "AI-powered Concrete Quick-Quote",
            icon: "zapierchat.png",
            htmlPath: "ConcQuoteBot.html",
            category: .ai,
            recentlyUpdatedInVersion: nil
        ),
        Dashboard(
            name: "Mix Design Assist",
            description: "AI Mix Design Selector",
            icon: "mixlogodesign.png",
            htmlPath: "MixDesignAI.html",
            category: .ai,
            recentlyUpdatedInVersion: nil
        ),

        // Plant Control
        Dashboard(
            name: "CHASCOmobile",
            description: "Plant Control Interface for CHASCO",
            icon: "chascologo.png",
            htmlPath: "index.html",
            category: .control,
            recentlyUpdatedInVersion: nil
        )
    ]

    static func dashboards(for category: DashboardCategory) -> [Dashboard] {
        allDashboards.filter { $0.category == category }
    }
}
