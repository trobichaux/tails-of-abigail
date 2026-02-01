# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

"Tails of Abigail" is a SwiftUI iOS application built with Xcode 26.2. The project uses SwiftData for persistent storage and is configured for iOS 26.2+ deployment on iPhone and iPad.

## Building and Running

### Build the project
```bash
xcodebuild -project "Tails of Abigail.xcodeproj" -scheme "Tails of Abigail" -configuration Debug build
```

### Build for release
```bash
xcodebuild -project "Tails of Abigail.xcodeproj" -scheme "Tails of Abigail" -configuration Release build
```

### Clean build folder
```bash
xcodebuild -project "Tails of Abigail.xcodeproj" -scheme "Tails of Abigail" clean
```

### Open in Xcode
```bash
open "Tails of Abigail.xcodeproj"
```

## Architecture

### SwiftData Model Layer
The app uses SwiftData for data persistence. The model layer is defined using the `@Model` macro:

- **Item.swift**: SwiftData model class marked with `@Model`. All data models should follow this pattern.
- **ModelContainer**: Configured in `Tails_of_AbigailApp.swift` with the app's schema. New models must be registered in the `Schema` array.

### SwiftUI View Layer
The app follows standard SwiftUI patterns:

- **ContentView.swift**: Main view using `@Query` for SwiftData queries and `@Environment(\.modelContext)` for data mutations
- Views access the model context through the environment, injected via `.modelContainer()` modifier on the WindowGroup

### App Entry Point
**Tails_of_AbigailApp.swift**: Main app structure that:
- Initializes the shared `ModelContainer` with registered models
- Configures persistent storage (set to `isStoredInMemoryOnly: false`)
- Injects the container into the view hierarchy

## Key Configuration

- **Bundle ID**: com.geekyonion.Tails-of-Abigail
- **Development Team**: 9W24T437Y9
- **Deployment Target**: iOS 26.2
- **Swift Version**: 5.0
- **Supported Devices**: iPhone and iPad (universal)
- **Swift Concurrency**: Uses approachable concurrency with `MainActor` isolation by default

### Entitlements
The app has the following capabilities enabled:
- CloudKit integration (development environment)
- Remote notifications background mode

## Working with SwiftData

When adding new data models:
1. Create the model class with `@Model` macro in a new Swift file
2. Add the model to the `Schema` array in `Tails_of_AbigailApp.swift`
3. Use `@Query` in views to fetch data
4. Use `modelContext.insert()` to create new items
5. Use `modelContext.delete()` to remove items

## File Structure

```
Tails of Abigail/
├── Models/
│   ├── Incident.swift            # Incident tracking model
│   ├── Room.swift                # Room configuration model
│   └── Furniture.swift           # Furniture configuration model
├── Views/
│   ├── Calendar/
│   │   ├── CalendarView.swift
│   │   ├── DayCell.swift
│   │   └── IncidentListForDateView.swift
│   ├── Incidents/
│   │   ├── IncidentListView.swift
│   │   └── IncidentDetailView.swift
│   ├── Statistics/
│   │   └── StatisticsView.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   ├── RoomsSettingsView.swift
│   │   └── FurnitureSettingsView.swift
│   └── Components/
│       └── FilterMenu.swift
├── Utilities/
│   └── FilterState.swift         # Shared filtering state
├── Tails_of_AbigailApp.swift    # App entry point and ModelContainer setup
├── ContentView.swift             # TabView navigation
├── Assets.xcassets/              # App assets and resources
├── Info.plist                    # App configuration
└── Tails_of_Abigail.entitlements # App capabilities
```

## App Features

- **Calendar View**: Monthly calendar with visual incident indicators and filtering
- **Incident List**: Chronological view of all incidents with filtering
- **Statistics**: 30/60/90 day charts with summary metrics
- **Settings**: Manage rooms and furniture (add/edit/delete/reorder)
- **Filtering**: Cross-view filtering by room and furniture

## Deployment (After Apple Developer Enrollment)

### Prerequisites
- Apple Developer Account ($99/year) - https://developer.apple.com/programs/
- Enrollment must be complete before proceeding

### Step 1: Configure Code Signing

1. **Add Apple ID to Xcode:**
   - Open Xcode → Settings → Accounts
   - Click "+" and add your Apple Developer account
   - Sign in and download manual profiles

2. **Enable Automatic Signing:**
   - Select project in Xcode navigator
   - Select "Tails of Abigail" target
   - Go to "Signing & Capabilities" tab
   - Check "Automatically manage signing"
   - Select your Team from dropdown (9W24T437Y9 or your new team)

3. **Verify Bundle Identifier:**
   - Current: `com.geekyonion.Tails-of-Abigail`
   - Change if needed in Target → General → Bundle Identifier

### Step 2: Prepare App Assets

1. **Create App Icon:**
   - Design 1024x1024 icon
   - Add to `Assets.xcassets/AppIcon`
   - Xcode will generate other required sizes

2. **Update Version Information:**
   - Target → General → Version (e.g., "1.0.0")
   - Target → General → Build (e.g., "1")

3. **Add Privacy Descriptions (if needed):**
   - Edit Info.plist if app requires camera, photos, location, etc.

### Step 3: Test on Physical Device

1. **Connect iPhone via USB**
2. **Select device** in Xcode device selector
3. **Press Cmd+R** to build and run
4. **First time only:**
   - On iPhone: Settings → General → VPN & Device Management
   - Tap your developer certificate → Trust

### Step 4: TestFlight Beta Testing

1. **Archive the app:**
   ```
   - In Xcode, select "Any iOS Device (arm64)" as destination
   - Product → Archive
   - Wait for archive to complete
   ```

2. **Upload to App Store Connect:**
   ```
   - Organizer window opens automatically
   - Select your archive → "Distribute App"
   - Choose "App Store Connect"
   - Follow prompts to upload
   ```

3. **Set up TestFlight:**
   ```
   - Go to https://appstoreconnect.apple.com
   - Select your app
   - Go to TestFlight tab
   - Add internal testers (up to 100)
   - Add external testers (up to 10,000, requires Apple review)
   ```

### Step 5: App Store Submission

1. **Create App Store Listing:**
   - Go to https://appstoreconnect.apple.com
   - Create new app if not exists
   - Fill in required metadata:
     - App name
     - Description (4000 chars max)
     - Keywords
     - Screenshots (iPhone and iPad sizes)
     - Privacy policy URL (if collecting data)
     - Support URL

2. **Set Pricing:**
   - Choose Free or Paid
   - Select territories

3. **Submit for Review:**
   - Select your uploaded build
   - Complete all required fields
   - Submit for review
   - Review typically takes 1-3 days

### Step 6: Post-Submission

- **Monitor status** in App Store Connect
- **Respond to reviewer questions** if needed
- **Celebrate launch!** 🎉

### Development Commands

```bash
# Build for simulator (development)
xcodebuild -project "Tails of Abigail.xcodeproj" \
  -scheme "Tails of Abigail" \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build

# Build for device (requires code signing)
xcodebuild -project "Tails of Abigail.xcodeproj" \
  -scheme "Tails of Abigail" \
  -configuration Release \
  build
```

### Troubleshooting

**Code signing issues:**
- Verify Apple Developer account is active
- Check that Team is selected in Signing & Capabilities
- Try manual signing if automatic fails

**Archive fails:**
- Clean build folder: Product → Clean Build Folder
- Restart Xcode
- Check for compilation errors in Release configuration

**TestFlight upload fails:**
- Verify app version is unique (increment if needed)
- Check for missing required icons
- Review upload logs in Xcode Organizer
