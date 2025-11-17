# WaterTracker
A minimal and animation-driven hydration app built with SwiftUI.
WaterTracker helps users stay properly hydrated through a clean interface, smooth water animations, and a home-screen widget that displays real-time progress.

## Overview
WaterTracker calculates your daily hydration goal based on your weight and allows you to quickly track your intake with pre-set amounts or a custom value.
The app features fluid water animations that rise as you drink, a simple navigation layout, and a compact widget for quick access.

## Features
- Daily goal automatically calculated: weight × 35 ml
- Animated rising water effect
- Quick-add buttons (50 ml, 100 ml, 150 ml, 250 ml, or custom amount)
- Daily goal and progress percentage
- Minimal bottom tab bar (History, Tracker, Settings)

## Tech Stack

| Technology | Purpose |
|-----------|---------|
| **SwiftUI** | UI design, layout, animations |
| **WidgetKit** | Home-screen widget integration |
| **AppIntents** | Communication between app and widget |
| **Combine** | Reactive state updates |
| **Firebase (optional)** | Data storage if implemented later |


## Project Structure
WaterTracker/
│── Theme/                     # Colors, styles, typography
│── Views/                     # Main SwiftUI screens
│     ├── ContentView
│     ├── MainPageView
│     ├── RegisterView
│     ├── HistoryView
│     ├── SettingsView
│     └── TabBarView
│
│── WaterTrackerApp            # App entry point
│── Assets                     # App icons, images, colors
│
├── WaterWidget/               # Widget files
│     ├── AppIntent
│     ├── WaterProgressWidget
│     ├── WaterWidget
│     ├── WaterWidgetBundle
│     └── WaterWidgetControl
│
└── WaterWidgetExtension/      # Widget extension configuration


## Next Steps

- Add notification scheduling  
- Add themes and color personalization  
- Create streaks and achievements system  
- Add more fluid and dynamic water animations  
- Improve onboarding flow  
- Add weekly/monthly hydration insights  


## Installation

Clone the repository:

```bash
git clone https://github.com/EstrellaVer/Challenge2.git


