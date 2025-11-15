//
//  RegisterView.swift
//  WaterTracker
//
//  Created by Estrella Verdiguel on 11/11/25.
//

import SwiftUI

struct RegisterView: View {
    @State private var weight: String = ""
    @State private var dailyGoal: Int = 0
    @State private var wakeUpTime = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var sleepTime = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var notificationInterval = 60
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                Spacer()
                Spacer()
                VStack(spacing: 50) {
                    VStack(spacing: 20) {
                        Text("Set Up Your Profile")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.blue)
                        
                        Text("Configure your hydration goal and schedule")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    
                    VStack(spacing: 30) {
                        TextField("Weight (kg)", text: $weight)
                            .font(.system(size: 25, weight: .medium))
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(100)
                            .multilineTextAlignment(.center)
                            .focused($isInputFocused)
                            .onChange(of: weight) { newValue in
                                if let w = Int(newValue) {
                                    dailyGoal = w * 35
                                } else {
                                    dailyGoal = 0
                                }
                            }
                        
                        VStack {
                            Text("Daily Goal:")
                                .font(.title3)
                                .foregroundColor(.black)
                            Text(dailyGoal > 0 ? "\(dailyGoal) ml" : "—")
                                .font(.system(size: 25, weight: .medium ))
                                .fontWeight(.medium)
                                .foregroundColor(Color.waveDark)
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 2)
                    
                    
                    VStack(spacing: 30) {
                        HStack {
                            Text("Wake Up")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Spacer()
                            DatePicker("", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        
                        
                        HStack {
                            Text("Sleep")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Spacer()
                            DatePicker("", selection: $sleepTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Reminders Every")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Picker("Interval", selection: $notificationInterval) {
                                Text("30 min").tag(30)
                                Text("1 hour").tag(60)
                                Text("2 hours").tag(120)
                            }
                            .pickerStyle(.segmented)
                            
                        }
                    }
                    
                    
                    NavigationLink(destination: TabBarView(goal: dailyGoal, reminderInterval: notificationInterval)) {
                        Text("Continue")
                            .font(.body)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(dailyGoal > 0 ? Color.blue : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(40)
                    }
                    .disabled(dailyGoal == 0)
                    .simultaneousGesture(TapGesture().onEnded {
                        isInputFocused = false
                    })
                    .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isInputFocused = false
            }
        }
    }
}

#Preview {
    RegisterView()
}


