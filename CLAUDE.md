# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**ABM.ai** is a native iOS application for operational intelligence in asphalt, concrete, and materials management. It provides real-time access to inventory levels, demand forecasts, driver schedules, AI-powered tools, and plant control systems through a glassmorphic SwiftUI interface.

**Repository:** https://github.com/davisdane2/ABMai

**Current Version:** 1.42 → 1.5 (v1.5 adds centralized data layer)

## Architecture

### Core Components

The app uses a **hybrid architecture** combining native SwiftUI with WKWebView-embedded HTML dashboards, enhanced in v1.5 with centralized data management:

#### View Layer
1. **DaneApp.swift** - App entry point, initializes DashboardDataManager
2. **ContentView.swift** - Main UI with glassmorphic design, category picker, and dashboard grid
3. **Dashboard.swift** - Data model defining 13 dashboards organized into 5 categories
4. **DashboardWebView.swift** - WKWebView wrapper with data injection support

#### Data Layer (v1.5+)
5. **DashboardDataManager.swift** - Central @ObservableObject managing all dashboard data
6. **SupabaseClient.swift** - Repository-pattern API client for Supabase
7. **DashboardDataModels.swift** - Codable models for all dashboard data types

### Data Flow (v1.5)
```
App Launch → DashboardDataManager starts background refresh (60s)
    ↓
SupabaseClient fetches all data in parallel (1 API call)
    ↓
Data cached to UserDefaults (offline support)
    ↓
Data injected into WebViews as window.centralizedDashboardData
    ↓
HTML dashboards use centralized data OR fetch independently (backward compatible)
```

### Dashboard Categories (DashboardCategory enum)

- `.inventory` - Chameleon pigments, Admixtures, Inventory submission
- `.demand` - Weekly demand analytics (Concrete, Asphalt, AC Oil, Powder, Raw Materials)
- `.operations` - Driver scheduling
- `.ai` - AI-powered tools (Concrete Quote AI, Mix Design Assist)
- `.control` - CHASCOmobile plant control interface

### HTML Dashboard Structure

Each dashboard lives in `Dane/DashboardAssets/{DashboardName}/` and is referenced by filename in Dashboard.swift's `htmlPath` property:

- HTML files are loaded via `Bundle.main.path(forResource:ofType:)`
- WKWebView loads HTML with `baseURL` set to the file's parent directory for relative asset loading
- Dashboards connect to **Supabase PostgreSQL** for real-time data
- Auto-refresh intervals: 30-90 seconds per dashboard

### UI Design System

**Glassmorphic Design** (introduced in v1.1):
- Frosted glass effects using `.ultraThinMaterial`
- White text on glass backgrounds for high contrast
- Gradient borders and shadows for depth
- Spring-based animations for interactions
- Background animated gradient with floating circles

Key reusable components in ContentView.swift:
- `GlassmorphicCard` - Container with frosted glass styling
- `GlassmorphicDashboardCard` - Dashboard card with icon, name, description
- `GlassmorphicToast` - Toast notifications with animations
- `ScaleButtonStyle` - Press animations for buttons

## Development Commands

### Build and Run

```bash
# Build for iOS Simulator
xcodebuild -scheme Dane -sdk iphonesimulator -configuration Debug build

# Run in simulator (after building)
xcrun simctl list  # List available simulators
xcrun simctl boot "iPhone 15 Pro"  # Boot specific simulator
open -a Simulator  # Open Simulator.app
xcrun simctl install booted /path/to/Dane.app
xcrun simctl launch booted com.antiochbuilding.Dane
```

### Testing

```bash
# Run unit tests
xcodebuild test -scheme Dane -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# Run specific test
xcodebuild test -scheme Dane -destination 'platform=iOS Simulator,name=iPhone 15 Pro' -only-testing:DaneTests/DaneTests/testExample
```

### Version Management

Version is controlled by `MARKETING_VERSION` in `Dane.xcodeproj/project.pbxproj`.

**Versioning policy:** Increment by 0.1 for each build (1.0 → 1.1 → 1.2 ... → 2.0)

To update version programmatically:
```bash
# Replace X.Y with current version, X.Z with next version
sed -i '' 's/MARKETING_VERSION = X.Y;/MARKETING_VERSION = X.Z;/g' Dane.xcodeproj/project.pbxproj
```

Update VERSION.md after each version bump with release notes.

### TestFlight Distribution

```bash
# Archive for distribution
xcodebuild -scheme Dane -sdk iphoneos -configuration Release archive -archivePath ./build/Dane.xcarchive

# Export IPA for TestFlight
xcodebuild -exportArchive -archivePath ./build/Dane.xcarchive -exportPath ./build -exportOptionsPlist ExportOptions.plist
```

## Key Files & Their Roles

### View Layer
- **Dashboard.swift:128** - `allDashboards` array contains all dashboard definitions; add new dashboards here
- **ContentView.swift:11** - `selectedCategory` state controls which category is displayed
- **DashboardWebView.swift** - WKWebView implementation with data injection at lines 148-193

### Data Layer (v1.5+)
- **DashboardDataManager.swift** - Central data orchestrator with background refresh
  - `startBackgroundRefresh()` - Starts 60s timer for data updates
  - `fetchAllData()` - Parallel fetch of all dashboard endpoints
  - `exportAsJSON()` - Prepares data for WebView injection
- **SupabaseClient.swift** - Repository pattern API client
  - `fetchAllDashboardData()` - Parallel batch fetch
  - Individual fetch methods for each dashboard type
- **DashboardDataModels.swift** - Cross-platform Codable models

### Documentation
- **VERSION.md** - Version history and update instructions
- **V1.5-IMPLEMENTATION.md** - v1.5 setup guide and architecture details

## Important Implementation Details

### Adding New Dashboards

1. Create HTML file in `Dane/DashboardAssets/{DashboardName}/`
2. Add to Xcode project (File → Add Files to "Dane")
3. Add Dashboard definition to `Dashboard.swift:28` in `allDashboards` array
4. Include: name, description, icon (emoji or .png filename), htmlPath, category
5. For image icons: place in `Dane/DashboardAssets/Dashboardlogos/` and add to Xcode

### HTML Dashboard Requirements

- Must be self-contained or use relative paths for assets
- Include Supabase connection code if using database
- Mobile-optimized viewport: `<meta name="viewport" content="width=device-width, initial-scale=1.0">`
- Handle auto-refresh with JavaScript timers if needed

### Icon Loading Logic

Icons can be emojis or image files:
- **Emoji:** Just use the emoji string (e.g., "🦎")
- **Image:** Use filename with extension (e.g., "cemexlogo.png")
- Images loaded from bundle via `loadImageFromBundle()` helper (ContentView.swift:260)
- Fallback to SF Symbol "app.fill" if image not found

## Database & Backend

- **Backend:** Supabase PostgreSQL
- **Authentication:** Currently anonymous key (public read access)
- **Security:** RLS (Row Level Security) planned for production
- **Data Access:** Direct REST API queries from HTML dashboards

## Distribution & Deployment

**Platform:** iOS 17.0+ (iPhone & iPad)

**Distribution Method:** TestFlight Beta
- Users receive email invitation with unique code
- Install TestFlight app from App Store
- Redeem code in TestFlight to access ABM.ai
- Automatic updates delivered via TestFlight

**Bundle Identifier:** com.antiochbuilding.Dane (assumed based on project structure)

## Roadmap Context

**Current Phase (v1.x):** Hybrid prototype with WKWebView dashboards

**Next Phase (v2.0):** Native SwiftUI migration
- Replace WKWebViews with native SwiftUI views
- Integrate Supabase Swift SDK
- Add real-time subscriptions
- Implement offline caching
- Native authentication
- Centralized data layer with background refresh (eliminates per-WebView queries)

**Future Phases:**
- **Android Migration** - All architectural decisions should consider cross-platform compatibility
  - Use platform-agnostic data models and business logic
  - Prefer shared patterns (e.g., centralized data layer, repository pattern)
  - Avoid iOS-specific dependencies where possible
  - Document platform-specific code clearly for easier porting
- CHASCOmobile SCADA integration with VPN
- Push notifications
- Multi-user collaboration
- PDF/Excel export capabilities

## Cross-Platform Considerations

**IMPORTANT:** All new features and architectural changes must be designed with eventual Android migration in mind.

### Data Layer Strategy
- Use **repository pattern** for data access (easily portable to Kotlin/Jetpack Compose)
- Keep business logic separate from UI code
- Use platform-agnostic JSON models
- Centralized Supabase client configuration

### Recommended Architecture (v2.0+)
```
┌─────────────────────────────────────┐
│  UI Layer (SwiftUI → Compose later) │
├─────────────────────────────────────┤
│  ViewModels/Presenters             │  ← Platform-specific but thin
├─────────────────────────────────────┤
│  Repository Layer                   │  ← Easily portable
├─────────────────────────────────────┤
│  Data Sources (Supabase, Local DB) │  ← Same patterns on both platforms
└─────────────────────────────────────┘
```

### Avoid
- Heavy use of iOS-specific frameworks (UIKit, CoreData)
- Tight coupling between UI and data fetching
- Platform-specific serialization (use Codable → kotlinx.serialization patterns)

## GitHub Workflow

There is a GitHub Actions workflow configured (visible in git status). Standard git workflow:

```bash
# Stage and commit changes
git add .
git commit -m "Description of changes

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Push to remote
git push origin main

# Create pull request (if working on branch)
gh pr create --title "PR title" --body "PR description"
```

## Contact & Support

- **Developer:** dane@antiochbuilding.com
- **Issues:** https://github.com/davisdane2/ABMai/issues
- **Company:** Antioch Building Materials (ABM)
