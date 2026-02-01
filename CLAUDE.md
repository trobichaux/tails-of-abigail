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
├── Tails_of_AbigailApp.swift    # App entry point and ModelContainer setup
├── ContentView.swift             # Main UI view
├── Item.swift                    # SwiftData model example
├── Assets.xcassets/              # App assets and resources
├── Info.plist                    # App configuration
└── Tails_of_Abigail.entitlements # App capabilities
```
