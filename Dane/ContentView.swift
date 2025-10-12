//
//  ContentView.swift
//  Dane
//
//  Created by Dane Davis on 10/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedCategory: DashboardCategory = .inventory
    @State private var showToast = false
    @State private var toastMessage = ""

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.1, blue: 0.3),
                        Color(red: 0.2, green: 0.1, blue: 0.4),
                        Color(red: 0.1, green: 0.2, blue: 0.5)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Animated background elements
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .offset(
                            x: CGFloat.random(in: -200...200),
                            y: CGFloat.random(in: -200...200)
                        )
                        .animation(
                            .easeInOut(duration: Double.random(in: 3...6))
                            .repeatForever(autoreverses: true),
                            value: UUID()
                        )
                }
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Glassmorphic Header
                        VStack(spacing: 12) {
                            Text("ABM.ai")
                                .font(.system(size: 52, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, .white.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 0)

                            Text("dashboards")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 20)

                        // Glassmorphic Category Picker
                        GlassmorphicCard {
                            VStack(spacing: 16) {
                                Text("Select Category")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                
                                Picker("Category", selection: $selectedCategory) {
                                    ForEach(DashboardCategory.allCases, id: \.self) { category in
                                        Text(category.rawValue).tag(category)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                            }
                            .padding(20)
                        }
                        .padding(.horizontal, 20)

                        // Glassmorphic Dashboard Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(Dashboard.dashboards(for: selectedCategory)) { dashboard in
                                NavigationLink(destination: DashboardDetailView(dashboard: dashboard)) {
                                    GlassmorphicDashboardCard(dashboard: dashboard)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
                
                // Toast Notification
                if showToast {
                    VStack {
                        Spacer()
                        GlassmorphicToast(message: toastMessage)
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .move(edge: .bottom).combined(with: .opacity)
                            ))
                            .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .onAppear {
            // Show welcome toast
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showToastMessage("Welcome to ABM.ai Dashboards!")
            }
        }
    }
    
    private func showToastMessage(_ message: String) {
        toastMessage = message
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            showToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showToast = false
            }
        }
    }
}

// MARK: - Glassmorphic Components

struct GlassmorphicCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct GlassmorphicDashboardCard: View {
    let dashboard: Dashboard
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Icon with glassmorphic background
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 70, height: 70)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                
                if dashboard.icon.hasSuffix(".png") || dashboard.icon.hasSuffix(".jpg") {
                    if let uiImage = loadImageFromBundle(named: dashboard.icon) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    } else {
                        Image(systemName: "app.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                } else {
                    Text(dashboard.icon)
                        .font(.system(size: 30))
                }
            }

            // Name
            Text(dashboard.name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            // Description
            Text(dashboard.description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity, minHeight: 140)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }

    // Helper function to load image from bundle
    private func loadImageFromBundle(named name: String) -> UIImage? {
        let baseName = name.replacingOccurrences(of: ".png", with: "")
            .replacingOccurrences(of: ".jpg", with: "")

        if let path = Bundle.main.path(forResource: baseName, ofType: "png") {
            return UIImage(contentsOfFile: path)
        } else if let path = Bundle.main.path(forResource: baseName, ofType: "jpg") {
            return UIImage(contentsOfFile: path)
        }
        return nil
    }
}

struct GlassmorphicToast: View {
    let message: String
    @State private var showIcon = false
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .scaleEffect(showIcon ? 1.0 : 0.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showIcon)
            }
            
            Text(message)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showIcon = true
            }
        }
    }
}

// MARK: - Legacy DashboardCard (kept for compatibility)

struct DashboardCard: View {
    let dashboard: Dashboard

    var body: some View {
        VStack(spacing: 12) {
            // Icon - display image if it's a file, otherwise show as emoji
            if dashboard.icon.hasSuffix(".png") || dashboard.icon.hasSuffix(".jpg") {
                if let uiImage = loadImageFromBundle(named: dashboard.icon) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                } else {
                    // Fallback if image not found
                    Image(systemName: "app.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                }
            } else {
                // Display emoji
                Text(dashboard.icon)
                    .font(.system(size: 50))
            }

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

    // Helper function to load image from bundle
    private func loadImageFromBundle(named name: String) -> UIImage? {
        // Remove extension to get the base name
        let baseName = name.replacingOccurrences(of: ".png", with: "")
            .replacingOccurrences(of: ".jpg", with: "")

        // Try to load from bundle
        if let path = Bundle.main.path(forResource: baseName, ofType: "png") {
            return UIImage(contentsOfFile: path)
        } else if let path = Bundle.main.path(forResource: baseName, ofType: "jpg") {
            return UIImage(contentsOfFile: path)
        }
        return nil
    }
}

#Preview {
    ContentView()
}
