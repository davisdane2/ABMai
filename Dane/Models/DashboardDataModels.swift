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

// Raw Material Demands
struct RawMaterialDemand: DashboardData, Codable {
    let plantName: String
    let materialCategory: String
    let materialName: String
    let demandDate: String
    let quantityTons: Double
    let createdAt: String?
    let updatedAt: String?
    let lastUpdated: Date

    enum CodingKeys: String, CodingKey {
        case plantName = "plant_name"
        case materialCategory = "material_category"
        case materialName = "material_name"
        case demandDate = "demand_date"
        case quantityTons = "quantity_tons"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case lastUpdated = "last_updated"
    }
}

// Asphalt Demand
struct AsphaltDemand: DashboardData, Codable {
    let shipDate: String
    let plantId: Int
    let plantDescription: String
    let productNumber: String
    let productDescription: String
    let quantity: Double
    let unit: String
    let fetchedAt: String?
    let lastUpdated: Date

    enum CodingKeys: String, CodingKey {
        case shipDate = "ship_date"
        case plantId = "plant_id"
        case plantDescription = "plant_description"
        case productNumber = "product_number"
        case productDescription = "product_description"
        case quantity
        case unit
        case fetchedAt = "fetched_at"
        case lastUpdated = "last_updated"
    }
}

struct ConcreteDemand: DashboardData, Codable {
    let shipDate: String
    let plantId: Int
    let plantDescription: String
    let productNumber: String
    let productDescription: String
    let quantity: Double
    let unit: String
    let fetchedAt: String?
    let lastUpdated: Date

    enum CodingKeys: String, CodingKey {
        case shipDate = "ship_date"
        case plantId = "plant_id"
        case plantDescription = "plant_description"
        case productNumber = "product_number"
        case productDescription = "product_description"
        case quantity
        case unit
        case fetchedAt = "fetched_at"
        case lastUpdated = "last_updated"
    }
}

// Powder Demand (Cement, Flyash, Slag)
struct PowderDemand: DashboardData, Codable {
    let id: String
    let plantId: String
    let materialName: String?
    let shipDate: String?
    let quantity: String?
    let lastUpdated: Date

    enum CodingKeys: String, CodingKey {
        case id
        case plantId = "plant_id"
        case materialName = "material_name"
        case shipDate = "ship_date"
        case quantity
        case lastUpdated = "last_updated"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        plantId = try container.decode(String.self, forKey: .plantId)
        materialName = try? container.decode(String.self, forKey: .materialName)
        shipDate = try? container.decode(String.self, forKey: .shipDate)
        quantity = try? container.decode(String.self, forKey: .quantity)
        lastUpdated = try container.decodeIfPresent(Date.self, forKey: .lastUpdated) ?? Date()
    }
}

// MARK: - Operations Models

struct DriverSchedule: DashboardData, Codable {
    let driverName: String?
    let driverId: String?
    let scheduleDate: String?
    let startTime: String?
    let endTime: String?
    let routeName: String?
    let vehicleId: String?
    let workPoint: String?
    let truckName: String?
    let status: String?
    let active: Bool?
    let fetchedAt: String?
    let lastUpdated: Date

    enum CodingKeys: String, CodingKey {
        case driverName = "driver_name"
        case driverId = "driver_id"
        case scheduleDate = "schedule_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case routeName = "route_name"
        case vehicleId = "vehicle_id"
        case workPoint = "work_point"
        case truckName = "truck_name"
        case status
        case active
        case fetchedAt = "fetched_at"
        case lastUpdated = "last_updated"
    }
}

// MARK: - Response Wrappers (for easier JSON handling)

struct DashboardDataSnapshot: Codable {
    let chameleonInventory: [ChameleonInventory]?
    let admixInventory: [AdmixInventory]?
    let concreteDemand: [ConcreteDemand]?
    let asphaltDemand: [AsphaltDemand]?
    let rawMaterialDemands: [RawMaterialDemand]?
    let powderDemand: [PowderDemand]?
    let driverSchedule: [DriverSchedule]?
    let fetchedAt: Date

    enum CodingKeys: String, CodingKey {
        case chameleonInventory = "chameleon_inventory"
        case admixInventory = "admix_inventory"
        case concreteDemand = "concrete_demand"
        case asphaltDemand = "asphalt_demand"
        case rawMaterialDemands = "raw_material_demands"
        case powderDemand = "powder_demand"
        case driverSchedule = "driver_schedule"
        case fetchedAt = "fetched_at"
    }

    init(
        chameleonInventory: [ChameleonInventory]? = nil,
        admixInventory: [AdmixInventory]? = nil,
        concreteDemand: [ConcreteDemand]? = nil,
        asphaltDemand: [AsphaltDemand]? = nil,
        rawMaterialDemands: [RawMaterialDemand]? = nil,
        powderDemand: [PowderDemand]? = nil,
        driverSchedule: [DriverSchedule]? = nil,
        fetchedAt: Date = Date()
    ) {
        self.chameleonInventory = chameleonInventory
        self.admixInventory = admixInventory
        self.concreteDemand = concreteDemand
        self.asphaltDemand = asphaltDemand
        self.rawMaterialDemands = rawMaterialDemands
        self.powderDemand = powderDemand
        self.driverSchedule = driverSchedule
        self.fetchedAt = fetchedAt
    }
}
