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
    case demand = "Weekly Demand"
    case operations = "Operations"
    case ai = "AI Tools"
    case control = "Plant Control"
}

extension Dashboard {
    static let allDashboards = [
        // Inventory Dashboards
        Dashboard(
            name: "Chameleon Inventory",
            description: "Pigment color inventory tracking",
            icon: "🦎",
            htmlPath: "DashboardAssets/ChameleonInventory/chameleon.html",
            category: .inventory
        ),
        Dashboard(
            name: "Admix Inventory",
            description: "Admixture inventory status",
            icon: "💧",
            htmlPath: "DashboardAssets/AdmixInventory/Admix.html",
            category: .inventory
        ),
        Dashboard(
            name: "Inventory Submission",
            description: "Submit inventory updates",
            icon: "📝",
            htmlPath: "DashboardAssets/InventorySubmission/InventorySubmission.html",
            category: .inventory
        ),

        // Weekly Demand Dashboards
        Dashboard(
            name: "Concrete Demand",
            description: "Weekly concrete demand analytics",
            icon: "🏗️",
            htmlPath: "DashboardAssets/ConcreteDemandWeekly/ConcWeekly.html",
            category: .demand
        ),
        Dashboard(
            name: "Asphalt Demand",
            description: "Weekly asphalt demand analytics",
            icon: "🛣️",
            htmlPath: "DashboardAssets/AsphaltDemandWeekly/AsphaltWeekly.html",
            category: .demand
        ),
        Dashboard(
            name: "A-Coil Demand",
            description: "Weekly A-Coil tracking",
            icon: "🔧",
            htmlPath: "DashboardAssets/ACoilWeekly/ACoilWeekly.html",
            category: .demand
        ),
        Dashboard(
            name: "Powder Demand",
            description: "Weekly powder demand",
            icon: "⚗️",
            htmlPath: "DashboardAssets/PowderWeekly/PowderWeekly.html",
            category: .demand
        ),
        Dashboard(
            name: "Raw Materials",
            description: "Combined raw material demand",
            icon: "📦",
            htmlPath: "DashboardAssets/RawMaterialDemandCombWeekly/RawWeeklyComb.html",
            category: .demand
        ),

        // Operations
        Dashboard(
            name: "Driver Schedule",
            description: "Driver scheduling dashboard",
            icon: "🚚",
            htmlPath: "DashboardAssets/ScheduleDashboard/ScheduleDash.html",
            category: .operations
        ),

        // AI Tools
        Dashboard(
            name: "Concrete Quote AI",
            description: "AI-powered concrete quotes",
            icon: "🤖",
            htmlPath: "DashboardAssets/ConcreteQuoteAI/ConcQuoteBot.html",
            category: .ai
        ),
        Dashboard(
            name: "Mix Design Assist",
            description: "AI mix design assistance",
            icon: "🧪",
            htmlPath: "DashboardAssets/MixDesignAssistAI/MixDesignAI.html",
            category: .ai
        ),

        // Plant Control
        Dashboard(
            name: "CHASCO Mobile",
            description: "SCADA plant control interface",
            icon: "⚙️",
            htmlPath: "DashboardAssets/CHASCOmobile/index.html",
            category: .control
        )
    ]

    static func dashboards(for category: DashboardCategory) -> [Dashboard] {
        allDashboards.filter { $0.category == category }
    }
}
