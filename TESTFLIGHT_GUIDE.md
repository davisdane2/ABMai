# TestFlight Distribution Guide for ABM.ai

## Current Build Settings (VERIFIED ✅)

### Key Settings:
- **Bundle Identifier:** `net.davisdane.abmai`
- **Team ID:** `SZ96693XF6`
- **Version:** 1.4 (MARKETING_VERSION)
- **Build:** 1.4 (CURRENT_PROJECT_VERSION)
- **iOS Deployment Target:** 17.0 (supports iOS 17.0+)
- **Code Signing:** Automatic
- **App Sandbox:** NO (correct for iOS)
- **Display Name:** ABM.ai

### Important: Version Numbering
- Increment `MARKETING_VERSION` for each release (e.g., 1.4 → 1.5)
- Increment `CURRENT_PROJECT_VERSION` for each build (Apple requires this to be unique)
- See VERSION.md for versioning policy

## Building for TestFlight

### Step 1: Archive the App

```bash
# Clean build folder
xcodebuild clean -scheme Dane

# Create archive
xcodebuild archive \
  -scheme Dane \
  -sdk iphoneos \
  -configuration Release \
  -archivePath ./build/ABM.ai.xcarchive
```

### Step 2: Export IPA for TestFlight

```bash
# Export using ExportOptions.plist
xcodebuild -exportArchive \
  -archivePath ./build/ABM.ai.xcarchive \
  -exportPath ./build \
  -exportOptionsPlist ExportOptions.plist
```

This creates `./build/ABM.ai.ipa` ready for upload.

### Step 3: Upload to App Store Connect

**Option A: Using Xcode**
1. Open Xcode
2. Window → Organizer
3. Select your archive
4. Click "Distribute App"
5. Choose "App Store Connect"
6. Follow the wizard

**Option B: Using Transporter App**
1. Open Transporter app (from Mac App Store)
2. Drag and drop `ABM.ai.ipa`
3. Click "Deliver"

**Option C: Using Command Line (xcrun altool)**
```bash
xcrun altool --upload-app \
  --type ios \
  --file ./build/ABM.ai.ipa \
  --username "your-apple-id@email.com" \
  --password "app-specific-password"
```

### Step 4: Distribute via TestFlight

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select ABM.ai
3. Go to TestFlight tab
4. Wait for build to process (~5-15 minutes)
5. Add build to testers:
   - Internal Testing: Up to 100 testers (team members)
   - External Testing: Submit for review, then up to 10,000 testers

## ExportOptions.plist Explanation

```xml
<key>method</key>
<string>app-store</string>          <!-- For TestFlight/App Store -->

<key>teamID</key>
<string>SZ96693XF6</string>         <!-- Your Apple Developer Team ID -->

<key>signingStyle</key>
<string>automatic</string>          <!-- Let Xcode handle signing -->

<key>destination</key>
<string>upload</string>             <!-- Upload to App Store Connect -->

<key>manageAppVersionAndBuildNumber</key>
<false/>                            <!-- We manage versions manually -->
```

## Common Issues & Solutions

### Issue: "No suitable application records were found"
**Solution:** Ensure bundle ID `net.davisdane.abmai` is registered in App Store Connect.

### Issue: "Code signing error"
**Solution:**
- Open Xcode → Preferences → Accounts
- Ensure your Apple ID is signed in
- Click "Download Manual Profiles"

### Issue: "Invalid deployment target"
**Solution:** Our deployment target is iOS 17.0, which is correct. If issues persist, check that you're using the latest Xcode.

### Issue: "Missing compliance"
**Solution:** We have `INFOPLIST_KEY_ITSAppUsesNonExemptEncryption = NO` set, indicating no encryption. This should auto-handle compliance.

## Pre-Flight Checklist

Before uploading to TestFlight:

- [ ] Version number incremented in project settings
- [ ] Build number incremented (must be unique)
- [ ] Tested on iOS Simulator (iPhone and iPad)
- [ ] All dashboards load properly
- [ ] WebView lifecycle working (no API spam)
- [ ] App icon displays correctly
- [ ] No debug code or console logs in release
- [ ] Updated VERSION.md with release notes

## Testing After Upload

Once build is available in TestFlight:

1. Install TestFlight app on device
2. Accept invitation (if external tester)
3. Install ABM.ai from TestFlight
4. Test all 13 dashboards:
   - Inventory: Chameleon, Admix, Submission
   - Demand: Concrete, Asphalt, AC Oil, Powder, Raw Materials
   - Operations: Driver Schedule
   - AI Tools: Concrete Quote AI, Mix Design Assist
   - Control: CHASCOmobile
5. Test navigation speed and WebView lifecycle
6. Report issues via TestFlight feedback button

## Helpful Commands

### Check current version/build
```bash
/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" \
  /Users/davisdane/Library/Developer/Xcode/DerivedData/Dane-*/Build/Products/Debug-iphonesimulator/ABM.ai.app/Info.plist
```

### List archives
```bash
ls -la ~/Library/Developer/Xcode/Archives/
```

### View build settings
```bash
xcodebuild -scheme Dane -showBuildSettings | grep -E "MARKETING|CURRENT_PROJECT|BUNDLE_IDENTIFIER"
```

## Resources

- [App Store Connect](https://appstoreconnect.apple.com)
- [TestFlight Documentation](https://developer.apple.com/testflight/)
- [Xcode Archive & Upload Guide](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)
