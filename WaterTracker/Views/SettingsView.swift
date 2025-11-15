//
//  SettingsView.swift
//  WaterTracker
//
//  Created by Estrella Verdiguel on 13/11/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("dailyGoal") private var dailyGoal: Int = 2000
    @AppStorage("reminderInterval") private var reminderInterval: Int = 60
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("darkModeEnabled") private var darkModeEnabled: Bool = false

    @State private var showSavedAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Daily Goal")) {
                    Stepper(value: $dailyGoal, in: 500...4000, step: 100) {
                        HStack {
                            Text("Goal: \(dailyGoal) ml")
                                .font(.subheadline)
                            Spacer()
                            Image(systemName: "drop.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }

                Section(header: Text("Reminders")) {
                    Stepper(value: $reminderInterval, in: 15...180, step: 15) {
                        HStack {
                            Text("Every \(reminderInterval) minutes")
                            Spacer()
                            Image(systemName: "bell.fill")
                                .foregroundColor(.orange)
                        }
                    }

                    Toggle(isOn: $notificationsEnabled) {
                        Label("Enable Notifications", systemImage: "bell.badge")
                    }
                }

                Section(header: Text("Appearance")) {
                    Toggle(isOn: $darkModeEnabled) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                    .onChange(of: darkModeEnabled) { _ in
                        updateAppearance()
                    }
                }

                Section(header: Text("About")) {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }
                

                Section {
                    Button(action: {
                        saveSettings()
                    }) {
                        HStack {
                            Spacer()
                            Text("Save Changes")
                                .bold()
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(8)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Settings Saved", isPresented: $showSavedAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }

    private func saveSettings() {
        showSavedAlert = true
        // Aquí puedes agregar lógica adicional (como guardar en UserDefaults o sincronizar datos)
    }

    private func updateAppearance() {
        if darkModeEnabled {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        }
    }
}

#Preview {
    SettingsView()
}

