//
//  ContentView.swift
//  Dane
//
//  Created by Dane Davis on 10/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedCategory: DashboardCategory = .inventory

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("ABM.ai")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        Text("dashboards")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)

                    // Category Picker
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(DashboardCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // Dashboard Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(Dashboard.dashboards(for: selectedCategory)) { dashboard in
                            NavigationLink(destination: DashboardDetailView(dashboard: dashboard)) {
                                DashboardCard(dashboard: dashboard)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct DashboardCard: View {
    let dashboard: Dashboard

    var body: some View {
        VStack(spacing: 12) {
            // Icon
            Text(dashboard.icon)
                .font(.system(size: 50))

            // Name
            Text(dashboard.name)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            // Description
            Text(dashboard.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ContentView()
}
