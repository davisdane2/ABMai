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
            category: .inventory
        ),
        Dashboard(
            name: "Admix Inventory",
            description: "Admixture (Dry Goods) Inventory for Bw & Pit",
            icon: "cemexlogo.png",
            htmlPath: "Admix.html",
            category: .inventory
        ),
        Dashboard(
            name: "Inventory Submission",
            description: "Update Inventories For BW & Pit + RAP area",
            icon: "deister.png",
            htmlPath: "InventorySubmission.html",
            category: .inventory
        ),

        // Weekly Demand Dashboards
        Dashboard(
            name: "Concrete Demand",
            description: "Weekly Concrete Demand",
            icon: "coneco.png",
            htmlPath: "ConcWeekly.html",
            category: .demand
        ),
        Dashboard(
            name: "Asphalt Demand",
            description: "Weekly Asphalt Demand",
            icon: "astelogo.png",
            htmlPath: "AsphaltWeekly.html",
            category: .demand
        ),
        Dashboard(
            name: "AC Oil Demand",
            description: "Weekly AC OIL Demand",
            icon: "acoillogo.png",
            htmlPath: "ACoilWeekly.html",
            category: .demand
        ),
        Dashboard(
            name: "Powder Demand",
            description: "Weekly Cement/Slag/Flyash Demand",
            icon: "cementlogo.png",
            htmlPath: "PowderWeekly.html",
            category: .demand
        ),
        Dashboard(
            name: "All Raw Material Demands",
            description: "Combined Raw Material Demands",
            icon: "rawmatlogo.png",
            htmlPath: "RawWeeklyComb.html",
            category: .demand
        ),

        // Operations
        Dashboard(
            name: "Driver Schedule",
            description: "Driver Start Times & Schedule",
            icon: "dflogo.png",
            htmlPath: "ScheduleDash.html",
            category: .operations
        ),

        // AI Tools
        Dashboard(
            name: "Concrete Quote AI",
            description: "AI-powered Concrete Quick-Quote",
            icon: "zapierchat.png",
            htmlPath: "ConcQuoteBot.html",
            category: .ai
        ),
        Dashboard(
            name: "Mix Design Assist",
            description: "AI Mix Design Selector",
            icon: "mixlogodesign.png",
            htmlPath: "MixDesignAI.html",
            category: .ai
        ),

        // Plant Control
        Dashboard(
            name: "CHASCOmobile",
            description: "Plant Control Interface for CHASCO",
            icon: "chascologo.png",
            htmlPath: "index.html",
            category: .control
        )
    ]

    static func dashboards(for category: DashboardCategory) -> [Dashboard] {
        allDashboards.filter { $0.category == category }
    }
}
