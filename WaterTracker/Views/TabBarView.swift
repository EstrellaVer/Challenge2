//
//  TabBar.swift
//  WaterTracker
//
//  Created by Estrella Verdiguel on 11/11/25.
//

import SwiftUI

struct TabBarView: View {
    @State private var activeTab: TabKey = .drop
    let goal: Int               
    let reminderInterval: Int
    
    var body: some View {
        HStack {
            TabView(selection: $activeTab) {
                Tab("History", systemImage: "calendar", value: TabKey.chart) {
                    HistoryView()
                }
                Tab("Tracker", systemImage: "drop", value: TabKey.drop) {
                    MainPageView(goal: goal, reminderInterval: reminderInterval )
                }
                Tab("Settings", systemImage: "gearshape", value: TabKey.settings) {
                    SettingsView()
                }
            }.tint(Color.waveMedium)
                .tabBarMinimizeBehavior(.onScrollDown)
        }
        .navigationBarBackButtonHidden(true)
    }
        
}

#Preview {
    TabBarView(goal: 1955, reminderInterval: 30)
}

private enum TabKey {
    case drop, chart, settings
}
