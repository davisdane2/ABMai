//
//  SupabaseClient.swift
//  Dane
//
//  Created by Dane Davis on 10/14/25.
//  Cross-platform compatible Supabase API client
//  Architecture pattern: Repository pattern for easy Android migration
//

import Foundation

// MARK: - Supabase Configuration
enum SupabaseConfig {
    static let url = "https://ntgxamggdtolnlevskjb.supabase.co"
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im50Z3hhbWdnZHRvbG5sZXZza2piIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkyNTE3NDMsImV4cCI6MjA3NDgyNzc0M30.r18wk6hrD3Qr4PgoQXIqskDsJCKO9jvLQCHQDDtJQvI"

    static var headers: [String: String] {
        [
            "apikey": anonKey,
            "Authorization": "Bearer \(anonKey)",
            "Content-Type": "application/json"
        ]
    }
}

// MARK: - Network Error Types
enum SupabaseError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(statusCode: Int, message: String)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Data parsing error: \(error.localizedDescription)"
        case .serverError(let code, let message):
            return "Server error (\(code)): \(message)"
        case .noData:
            return "No data received from server"
        }
    }
}

// MARK: - Supabase Client
class SupabaseClient {

    static let shared = SupabaseClient()

    private let session: URLSession
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder

    init(session: URLSession = .shared) {
        self.session = session

        // Configure JSON decoder for Supabase date formats
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.dateDecodingStrategy = .iso8601
        self.jsonDecoder.keyDecodingStrategy = .useDefaultKeys

        self.jsonEncoder = JSONEncoder()
        self.jsonEncoder.dateEncodingStrategy = .iso8601
    }

    // MARK: - Generic Fetch Method
    private func fetch<T: Decodable>(
        endpoint: String,
        query: String = ""
    ) async throws -> T {
        let urlString = "\(SupabaseConfig.url)/rest/v1/\(endpoint)\(query)"

        guard let url = URL(string: urlString) else {
            throw SupabaseError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        for (key, value) in SupabaseConfig.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw SupabaseError.noData
            }

            // Handle HTTP errors
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw SupabaseError.serverError(
                    statusCode: httpResponse.statusCode,
                    message: errorMessage
                )
            }

            // Decode response
            do {
                let decoded = try jsonDecoder.decode(T.self, from: data)
                return decoded
            } catch {
                throw SupabaseError.decodingError(error)
            }

        } catch let error as SupabaseError {
            throw error
        } catch {
            throw SupabaseError.networkError(error)
        }
    }

    // MARK: - Dashboard-Specific Fetch Methods

    /// Fetch chameleon inventory for all plants
    func fetchChameleonInventory() async throws -> [ChameleonInventory] {
        return try await fetch(endpoint: "chameleon_inventory", query: "?select=*")
    }

    /// Fetch admix inventory for all plants
    func fetchAdmixInventory() async throws -> [AdmixInventory] {
        return try await fetch(endpoint: "admix_inventory", query: "?select=*")
    }

    /// Fetch concrete demand data
    func fetchConcreteDemand() async throws -> [ConcreteDemand] {
        return try await fetch(endpoint: "concrete_demand", query: "?select=*&order=ship_date.desc")
    }

    /// Fetch raw material demands
    func fetchRawMaterialDemands() async throws -> [RawMaterialDemand] {
        return try await fetch(endpoint: "raw_material_demands", query: "?select=*&order=demand_date.desc")
    }

    /// Fetch asphalt demand
    func fetchAsphaltDemand() async throws -> [AsphaltDemand] {
        return try await fetch(endpoint: "asphalt_demand", query: "?select=*&order=ship_date.desc")
    }

    /// Fetch driver schedules
    func fetchDriverSchedule(date: String? = nil) async throws -> [DriverSchedule] {
        let query = date != nil
            ? "?schedule_date=eq.\(date!)&select=*&order=start_time.asc"
            : "?select=*&order=schedule_date.desc,start_time.asc&limit=50"
        return try await fetch(endpoint: "driver_schedule", query: query)
    }

    /// Fetch powder demand (cement, flyash, slag)
    func fetchPowderDemand() async throws -> [PowderDemand] {
        return try await fetch(endpoint: "powder_demand", query: "?select=*&order=ship_date.asc")
    }

    // MARK: - Batch Fetch (Parallel)

    /// Fetch all dashboard data in parallel for maximum efficiency
    func fetchAllDashboardData() async -> DashboardDataSnapshot {
        // Use async let for parallel fetching
        async let chameleon = try? fetchChameleonInventory()
        async let admix = try? fetchAdmixInventory()
        async let concrete = try? fetchConcreteDemand()
        async let asphalt = try? fetchAsphaltDemand()
        async let rawMaterials = try? fetchRawMaterialDemands()
        async let powder = try? fetchPowderDemand()
        async let schedule = try? fetchDriverSchedule()

        return DashboardDataSnapshot(
            chameleonInventory: await chameleon,
            admixInventory: await admix,
            concreteDemand: await concrete,
            asphaltDemand: await asphalt,
            rawMaterialDemands: await rawMaterials,
            powderDemand: await powder,
            driverSchedule: await schedule,
            fetchedAt: Date()
        )
    }
}

// MARK: - Convenience Extensions for Testing
extension SupabaseClient {
    /// Test connection to Supabase
    func testConnection() async -> Bool {
        do {
            let _: [ChameleonInventory] = try await fetch(endpoint: "chameleon_inventory", query: "?limit=1")
            return true
        } catch {
            print("Connection test failed: \(error.localizedDescription)")
            return false
        }
    }
}
