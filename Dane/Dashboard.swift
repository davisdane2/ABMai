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
}

enum DashboardCategory: String, CaseIterable {
    case inventory = "Inventory"
    case demand = "ProductDemands"
    case operations = "Schedule & DF"
    case ai = "AI ChatBot Tools"
    case control = "CHASCOmobile"
}

extension Dashboard {
    static let allDashboards = [
        // Inventory Dashboards
        Dashboard(
            name: "Chameleon Inventory",
            description: "Pittsburg & Brentwood chameleon inventory",
            icon: "🦎",
            htmlPath: "chameleon.html",
            category: .inventory
        ),
        Dashboard(
            name: "Admix Inventory",
            description: "Admixture & Dry Additives inventory Pit&BW",
            icon: "💧",
            htmlPath: "Admix.html",
            category: .inventory
        ),
        Dashboard(
            name: "Inventory Submission",
            description: "Update Inventories for your department",
            icon: "📝",
            htmlPath: "InventorySubmission.html",
            category: .inventory
        ),

        // Weekly Demand Dashboards
        Dashboard(
            name: "Concrete Demand",
            description: "Weekly concrete demand dashboard",
            icon: "🏗️",
            htmlPath: "ConcWeekly.html",
            category: .demand
        ),
        Dashboard(
            name: "Asphalt Demand",
            description: "Weekly asphalt demand dashboard",
            icon: "🛣️",
            htmlPath: "AsphaltWeekly.html",
            category: .demand
        ),
        Dashboard(
            name: "AC Oil Demand",
            description: "Weekly AC oil tracking",
            icon: "🔧",
            htmlPath: "ACoilWeekly.html",
            category: .demand
        ),
        Dashboard(
            name: "Powder Demand",
            description: "Weekly Cement/Slag/Flyash powder demand",
            icon: "⚗️",
            htmlPath: "PowderWeekly.html",
            category: .demand
        ),
        Dashboard(
            name: "All Raw Material Demands",
            description: "Combined raw material demand",
            icon: "📦",
            htmlPath: "RawWeeklyComb.html",
            category: .demand
        ),

        // Operations
        Dashboard(
            name: "Driver Schedule",
            description: "Driver scheduling dashboard",
            icon: "🚚",
            htmlPath: "ScheduleDash.html",
            category: .operations
        ),

        // AI Tools
        Dashboard(
            name: "Concrete Quote AI",
            description: "AI-powered concrete quotes",
            icon: "🤖",
            htmlPath: "ConcQuoteBot.html",
            category: .ai
        ),
        Dashboard(
            name: "Mix Design Assist",
            description: "AI mix design assistance",
            icon: "🧪",
            htmlPath: "MixDesignAI.html",
            category: .ai
        ),

        // Plant Control
        Dashboard(
            name: "CHASCOmobile",
            description: "plant control interface for CHASCO asphalt plant controls",
            icon: "⚙️",
            htmlPath: "index.html",
            category: .control
        )
    ]

    static func dashboards(for category: DashboardCategory) -> [Dashboard] {
        allDashboards.filter { $0.category == category }
    }
}
