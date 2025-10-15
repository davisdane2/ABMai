//
//  DashboardDataModels.swift
//  Dane
//
//  Created by Dane Davis on 10/14/25.
//  Cross-platform compatible data models for all dashboard types
//

import Foundation

// MARK: - Base Protocol
protocol DashboardData: Codable {
    var lastUpdated: Date { get }
}

// MARK: - Inventory Models

struct ChameleonInventory: DashboardData, Codable {
    let plantName: String
    let a1010: Double
    let a1070: Double
    let a550: Double
    let a875: Double
    let a8090: Double
    let lastRinseDate: String?
    let lastRinseTime: String?
    let updatedAt: String?
    let lastUpdated: Date

    enum CodingKeys: String, CodingKey {
        case plantName = "plant_name"
        case a1010, a1070, a550, a875, a8090
        case lastRinseDate = "last_rinse_date"
        case lastRinseTime = "last_rinse_time"
        case updatedAt = "updated_at"
        case lastUpdated = "last_updated"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        plantName = try container.decode(String.self, forKey: .plantName)
        a1010 = try container.decode(Double.self, forKey: .a1010)
        a1070 = try container.decode(Double.self, forKey: .a1070)
        a550 = try container.decode(Double.self, forKey: .a550)
        a875 = try container.decode(Double.self, forKey: .a875)
        a8090 = try container.decode(Double.self, forKey: .a8090)
        lastRinseDate = try? container.decode(String.self, forKey: .lastRinseDate)
        lastRinseTime = try? container.decode(String.self, forKey: .lastRinseTime)
        updatedAt = try? container.decode(String.self, forKey: .updatedAt)
        lastUpdated = try container.decodeIfPresent(Date.self, forKey: .lastUpdated) ?? Date()
    }
}

struct AdmixInventory: DashboardData, Codable {
    let plantName: String
    let productName: String
    let currentStock: Double
    let unit: String
    let reorderPoint: Double?
    let updatedAt: String?
    let lastUpdated: Date

    enum CodingKeys: String, CodingKey {
        case plantName = "plant_name"
        case productName = "product_name"
        case currentStock = "current_stock"
        case unit
        case reorderPoint = "reorder_point"
        case updatedAt = "updated_at"
        case lastUpdated = "last_updated"
    }
}

// MARK: - Demand Models

struct WeeklyDemand: DashboardData, Codable {
    let productType: String
    let weekNumber: Int
    let year: Int
    let plant: String
    let demandQuantity: Double
    let unit: String
    let updatedAt: String?
    let lastUpdated: Date

    enum CodingKeys: String, CodingKey {
        case productType = "product_type"
        case weekNumber = "week_number"
        case year
        case plant
        case demandQuantity = "demand_quantity"
        case unit
        case updatedAt = "updated_at"
        case lastUpdated = "last_updated"
    }
}

struct ConcreteDemand: DashboardData, Codable {
    let weekNumber: Int
    let year: Int
    let plant: String
    let mixType: String?
    let totalYards: Double
    let updatedAt: String?
    let lastUpdated: Date

    enum CodingKeys: String, CodingKey {
        case weekNumber = "week_number"
        case year
        case plant
        case mixType = "mix_type"
        case totalYards = "total_yards"
        case updatedAt = "updated_at"
        case lastUpdated = "last_updated"
    }
}

// MARK: - Operations Models

struct DriverSchedule: DashboardData, Codable {
    let driverName: String
    let startTime: String
    let endTime: String?
    let route: String?
    let truckNumber: String?
    let scheduleDate: String
    let notes: String?
    let lastUpdated: Date

    enum CodingKeys: String, CodingKey {
        case driverName = "driver_name"
        case startTime = "start_time"
        case endTime = "end_time"
        case route
        case truckNumber = "truck_number"
        case scheduleDate = "schedule_date"
        case notes
        case lastUpdated = "last_updated"
    }
}

// MARK: - Response Wrappers (for easier JSON handling)

struct DashboardDataSnapshot: Codable {
    let chameleonInventory: [ChameleonInventory]?
    let admixInventory: [AdmixInventory]?
    let concreteDemand: [ConcreteDemand]?
    let weeklyDemand: [WeeklyDemand]?
    let driverSchedule: [DriverSchedule]?
    let fetchedAt: Date

    enum CodingKeys: String, CodingKey {
        case chameleonInventory = "chameleon_inventory"
        case admixInventory = "admix_inventory"
        case concreteDemand = "concrete_demand"
        case weeklyDemand = "weekly_demand"
        case driverSchedule = "driver_schedule"
        case fetchedAt = "fetched_at"
    }

    init(
        chameleonInventory: [ChameleonInventory]? = nil,
        admixInventory: [AdmixInventory]? = nil,
        concreteDemand: [ConcreteDemand]? = nil,
        weeklyDemand: [WeeklyDemand]? = nil,
        driverSchedule: [DriverSchedule]? = nil,
        fetchedAt: Date = Date()
    ) {
        self.chameleonInventory = chameleonInventory
        self.admixInventory = admixInventory
        self.concreteDemand = concreteDemand
        self.weeklyDemand = weeklyDemand
        self.driverSchedule = driverSchedule
        self.fetchedAt = fetchedAt
    }
}
