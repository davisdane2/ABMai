# ABM.ai - Operational Dashboards

> Real-time operational intelligence for asphalt, concrete, and materials management

**ABM.ai** is a native iOS application that brings your entire operations ecosystem to your mobile device. Access live inventory levels, demand forecasts, driver schedules, AI-powered tools, and plant control systems—all from one beautifully designed interface.

![ABM.ai App Screenshot](Dane/readmeasset/screenshotgeneral.png)

---

## 🚀 Features

### 📊 Real-Time Dashboards

Access 13 live operational dashboards organized by category:

#### 🏭 **Inventory Management**
- **Chameleon Inventory** - Real-time pigment tracking for Pittsburg & Brentwood plants
  - Monitor A1010, A1070, A550, A875, A8090 levels
  - Track incoming orders and delivery schedules
  - EOD rinse status tracking
- **Admix Inventory** - Admixture and dry additives monitoring
  - DV1000, RECOVER, ISOFLEX series, ECLIPSE, ISOXEL, VMAR3
  - Dry goods tracking (fiber, XYPEX, expansion joints)
  - Multi-plant visibility
- **Inventory Submission** - Update inventory levels from anywhere

#### 📈 **Weekly Demand Analytics**
- **Concrete Demand** - Weekly concrete production forecasts
- **Asphalt Demand** - Asphalt production planning
- **AC Oil Demand** - Asphalt cement oil tracking
- **Powder Demand** - Cement, slag, and flyash monitoring
- **Raw Materials** - Combined material demand overview

#### 🚚 **Operations & Scheduling**
- **Driver Schedule** - Real-time driver scheduling dashboard
  - Organized by work point
  - Truck assignments
  - Start times and notes

#### 🤖 **AI-Powered Tools**
- **Concrete Quote AI** - Instant AI-generated concrete quotes
- **Mix Design Assist** - AI-powered mix design recommendations

#### ⚙️ **Plant Control**
- **CHASCOmobile** - SCADA plant control interface *(Preview)*

![CHASCOmobile SCADA Interface](Dane/readmeasset/screenshotchascomobile.png)

> **Coming Soon:** CHASCOmobile will provide full SCADA control and monitoring of the CHASCO asphalt plant directly from your iOS device. Real-time temperature monitoring, batch controls, and production metrics—all at your fingertips.

---

## 🛠️ Technical Stack

### Frontend
- **SwiftUI** - Modern iOS native interface
- **WKWebView** - Hybrid web content rendering
- **UIKit** - iOS framework integration

### Backend & Data
- **Supabase** - PostgreSQL database with real-time subscriptions
- **REST API** - Direct database queries
- **Auto-refresh** - 30-90 second polling intervals

### Dashboard Technologies
- **React** - Interactive dashboard components
- **Tailwind CSS** - Responsive styling
- **HTML5/JavaScript** - Web-based visualizations

### Data Sources
Database tables:
- `chameleon_inventory` & `chameleon_incoming_orders`
- `admix_inventory` & `admix_incoming_orders`
- `driver_schedules`
- Weekly demand tracking tables

---

## 📱 Platform Support

- **iOS 17.0+** - iPhone & iPad
- **macOS 14.0+** (coming soon)

---

## 🎯 Current Status

**Version:** 1.0 Beta
**Build Status:** ✅ Successfully builds for iOS Simulator
**Release Target:** TestFlight Beta (iOS & macOS)

---

## 🔮 Roadmap

### Phase 1 (Current - WKWebView Prototype) ✅
- [x] Dashboard selector interface
- [x] WKWebView integration for all 13 dashboards
- [x] Custom logo branding
- [x] Category-based navigation
- [x] Supabase connectivity

### Phase 2 (Native Migration)
- [ ] Migrate high-priority dashboards to native SwiftUI
- [ ] Integrate Supabase Swift SDK for direct database access
- [ ] Real-time subscriptions (replace polling)
- [ ] Offline capability with local caching
- [ ] Native authentication

### Phase 3 (CHASCOmobile Integration)
- [ ] Live SCADA data integration
- [ ] Plant control commands
- [ ] Real-time alerts and monitoring
- [ ] Production metrics dashboard

### Phase 4 (Advanced Features)
- [ ] Push notifications for inventory alerts
- [ ] Multi-user collaboration
- [ ] Custom dashboard builder
- [ ] Export reports (PDF/Excel)
- [ ] Apple Watch companion app

---

## 🏗️ Building the App

### Prerequisites
- Xcode 16.0+
- iOS 17.0+ SDK
- macOS Ventura or later

### Build Instructions

```bash
# Clone the repository
git clone https://github.com/davisdane2/ABMai.git
cd ABMai

# Open in Xcode
open Dane.xcodeproj

# Select target device (iPhone or Simulator)
# Press Cmd+R to build and run
```

### Run in Simulator
```bash
xcodebuild -project Dane.xcodeproj -scheme Dane \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' \
  build
```

---

## 📦 Project Structure

```
Dane/
├── Dashboard.swift           # Dashboard models and data
├── DashboardWebView.swift    # WKWebView wrapper
├── ContentView.swift         # Main UI
├── DaneApp.swift            # App entry point
├── DashboardAssets/         # HTML dashboards
│   ├── ChameleonInventory/
│   ├── AdmixInventory/
│   ├── ConcreteDemandWeekly/
│   ├── AsphaltDemandWeekly/
│   ├── ACoilWeekly/
│   ├── PowderWeekly/
│   ├── RawMaterialDemandCombWeekly/
│   ├── ScheduleDashboard/
│   ├── InventorySubmission/
│   ├── ConcreteQuoteAI/
│   ├── MixDesignAssistAI/
│   └── CHASCOmobile/
└── DashboardAssets/Dashboardlogos/  # Brand logos
```

---

## 🔐 Database Configuration

The app connects to a Supabase PostgreSQL database:
- **URL:** `https://ntgxamggdtolnlevskjb.supabase.co`
- **Authentication:** Anonymous key (public read access)

> **Security Note:** Production builds will implement Row Level Security (RLS) and proper authentication.

---

## 🤝 Contributing

This is a private enterprise application. For internal contributors:

1. Create a feature branch
2. Make your changes
3. Test thoroughly in simulator
4. Submit PR for review

---

## 📄 License

Proprietary - All Rights Reserved

---

## 📞 Support

For issues or questions:
- Internal: Contact Dane Davis
- GitHub: https://github.com/davisdane2/ABMai/issues

---

## 🎨 Branding

Dashboard logos and icons are proprietary to:
- CEMEX
- Deister Machine Co.
- ASTE (American Standard Testing & Engineering)
- CHASCO
- And partner organizations

---

## 🙏 Acknowledgments

Built with:
- **SwiftUI** by Apple
- **Supabase** for backend infrastructure
- **Claude Code** for AI-assisted development
- **React** & **Tailwind CSS** for dashboard UIs

---

**ABM.ai** - *Bringing operational excellence to your fingertips* 📱✨
