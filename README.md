# ABM.ai - Operational Dashboards

> Real-time operational intelligence for asphalt, concrete, and materials management

**ABM.ai** is a native iOS application that brings your entire operations ecosystem to your mobile device. Access live inventory levels, demand forecasts, driver schedules, AI-powered tools, and plant control systems—all from one interface.

![ABM.ai App Screenshot](Dane/readmeasset/screenshotgeneral.png)

---

## 📲 How to Install ABM.ai on Your iPhone

**New to TestFlight?** No problem! Follow these simple steps to get ABM.ai on your iPhone:

### Step 1: Check Your Email 📧

You'll receive an email invitation from **Dane Davis via TestFlight** with the subject line similar to "Join the ABM.ai beta test."

![Email Invitation](Dane/InstallInstructions/1%20-%20receivedemail%20to%20go%20and%20redeem%20invite%20code.png)

**Important:** Look for your **unique invitation code** in the email. It's easy to miss!

![Invitation Code Location](Dane/InstallInstructions/1.5%20-%20code%20easy%20to%20miss.png)

### Step 2: Download TestFlight 📱

Before you can install ABM.ai, you need the **TestFlight app** (it's free from Apple).

**Two ways to get it:**

**Option A:** Tap the link in your invitation email

**Option B:** [Download TestFlight from the App Store](https://apps.apple.com/us/app/testflight/id899247664)

> TestFlight is Apple's official app for testing beta software. It's safe and trusted by millions of developers.

### Step 3: Redeem Your Invitation Code 🎟️

1. **Open the TestFlight app** on your iPhone
2. **Sign in** with your Apple ID (the same one you use for the App Store)
3. Tap **"Redeem"** in the top right corner
4. **Enter your invitation code** from the email
5. Tap **"Redeem"** to activate

![Redeem Code in TestFlight](Dane/InstallInstructions/3%20-%20login%20apple%20id%20and%20activate%20dev%20to%20redeem%20code%20in%20TestFlight.png)

### Step 4: Install ABM.ai ✅

After redeeming your code, **ABM.ai** will appear in your TestFlight app.

![ABM.ai in TestFlight](Dane/InstallInstructions/4%20-%20app%20will%20show%20up%20in%20TestFlight.png)

1. Tap **"Install"** next to ABM.ai
2. Wait for the download to complete (usually takes 30-60 seconds)
3. Once installed, tap **"Open"** to launch the app

### Step 5: Find ABM.ai on Your Home Screen 🏠

After installation, **ABM.ai** appears on your iPhone home screen just like any other app!

![ABM.ai Working](Dane/InstallInstructions/5%20-%20app%20shows%20up%20and%20works%20like%20real%20app%20and%20auto%20updates.png)

**Bonus:** The app will **automatically update** whenever we release new features or fixes. You'll get a notification in TestFlight when updates are available.

---

### ❓ Troubleshooting

**Can't find the invitation email?**
- Check your spam/junk folder
- Make sure the email was sent to the correct address
- Contact Dane for a new invitation

**"Code Already Redeemed" error?**
- You may have already redeemed it! Check if ABM.ai is already in your TestFlight app
- If not, request a new code from Dane
  
**Need help?**
- Email: dane@antiochbuilding.com

---

## Main Features

### 🎨 **Glassmorphic Design Interface**
- **Modern UI**: glassmorphic design with frosted glass effects
- **Enhanced Readability**: High-contrast white text on glass backgrounds
- **Smooth Animations**: Spring-based interactions and floating elements
- **Premium Feel**: Professional gradient backgrounds and glassmorphic cards

### 📊 Real-Time Dashboards

Access 10 live operational dashboards and 3 WIP dashboards organized by category:

#### **Inventory Management**
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

####**Operations & Scheduling**
- **Driver Schedule** - Real-time driver scheduling dashboard
  - Organized by work point
  - Truck assignments
  - Start times and notes

#### 🤖 **AI-Powered Tools**
- **Concrete Quote AI** - Instant AI-generated concrete quotes with smart pricing algorithms
  - Form-based interface with project details, concrete types, and special requirements
  - Real-time quote calculations with volume discounts and delivery fees
  - Professional quote display with all project specifications
- **Mix Design Assist** - AI-powered mix design recommendations
  - Advanced mix design calculator with strength optimization
  - Water-cement ratio calculations based on exposure conditions
  - Material proportions and quality control recommendations
  - Professional mix design reports with industry standards

#### ⚙️ **Plant Control**
- **CHASCOmobile** - plant control interface with VPN integration

![CHASCOmobile VPN Connection](chascomobilevpn.png)

**NEW in v1.4:** Secure VPN connection to live CHASCO plant controls
- Click the VPN activation button to connect to your plant's SCADA system
- Safety warning modal ensures VPN is active before connecting
- Opens in Safari for reliable connection to `10.52.10.100`
- Real-time access to plant temperature monitoring, batch controls, and production metrics
- Navigate back and forth between app and plant controls seamlessly

> **Security Note:** Requires active VPN connection to access live plant controls. The app validates connection requirements before opening the external CHASCO interface.

---
## 📱 Platform Support
- **iOS 17.0+** - iPhone & iPad
- (coming soon) Android Support 
---
## 🎯 Current Status
**Version:** 1.4 Beta
**Release Target:** TestFlight edition (iOS & macOS)

### Recent Updates (v1.4)
- ✅ **CHASCOmobile VPN Integration** - Secure connection to live plant SCADA controls
- ✅ **Enhanced WebView Navigation** - Back/forward/reload controls for dashboard navigation
- ✅ **Safety Warnings** - VPN connection validation before accessing plant controls
- ✅ **Safari Integration** - External browser support for secure plant connections
---
### Phase 1 (Current - Prototype) ✅
- [x] Dashboard selector interface
- [x] WKWebView integration for all dashboards
- [x] Category-based navigation
- [x] Supabase connectivity for rapid data availability from selected data sources
- [x] **Glassmorphic UI Design** - Modern frosted glass interface with enhanced readability
- [x] **AI Tools Redesign** - Local, self-contained AI tools with professional interfaces

### Phase 2 (Native Migration)
- [ ] Migrate high-priority dashboards to native SwiftUI for a cleaner look
- [ ] Integrate Supabase Swift SDK for direct database access when running app.
- [ ] Real-time subscriptions to data should it change while viewing.
- [ ] Offline capability with local caching so the captured dashboard stays with out
- [ ] Native authentication to data services

### Phase 3 (CHASCOmobile Integration)
- [x] Secure VPN connection workflow (v1.4)
- [x] Safety validation and warning system (v1.4)
- [x] Safari integration for plant access (v1.4)

### Phase 4 (Advanced Features)
- [ ] Push notifications for inventory alerts and delivery updates
- [ ] Export reports (PDF/Excel)
- [ ] Email dashboard PDFs through email to share
- [ ] Manager level authentication for Financial Insight Dashboards

## 🔐
The app connects to a Supabase PostgreSQL database:
- **Authentication:** Anonymous key (public read access)
> **Security Note:** Production builds will implement Row Level Security (RLS) and proper authentication.
---
This is a private enterprise application. Intended for onsite access by ABM employees
For issues or questions:
- dane@antiochbuilding.com - GitHub: https://github.com/davisdane2/ABMai/issues
---
Dashboard logos and icons are proprietary to:
- CEMEX LLC - Deister Machine Co. - ASTEC (American Standard Testing & Engineering) - CHASCO Automation
Built with:
- **SwiftUI** by Apple
- **Supabase** for backend infrastructure
- **Claude Code** for AI-assisted development
- **React** & **Tailwind CSS** for dashboard UIs
---
