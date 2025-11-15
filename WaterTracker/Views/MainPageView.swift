//
//  MainPageView.swift
//  WaterTracker
//
//  Created by Estrella Verdiguel on 11/11/25.
//
import SwiftUI
import CoreMotion
import Combine

class MotionManager: ObservableObject {
    private var motion = CMMotionManager()
    @Published var gravityX: Double = 0.0

    init() {
        startMotionUpdates()
    }

    func startMotionUpdates() {
        if motion.isDeviceMotionAvailable {
            motion.deviceMotionUpdateInterval = 1.0 / 60.0
            motion.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
                guard let self = self, let data = data else { return }
                self.gravityX = data.gravity.x  // izquierda/derecha
            }
        }
    }
}


struct MainPageView: View {
    let goal: Int
    let reminderInterval: Int
    
    @State private var progress: CGFloat = 0.0
    @State private var waveOffset1: Double = 0
    @State private var waveOffset2: Double = 0
    @State private var waveOffset3: Double = 0
    @State private var currentIntake = 0
    @State private var timeRemaining: Int = 0
    @State private var timer: Timer? = nil
    @State private var showCustomAmountModal = false
    @State private var customAmount = ""
    
    @StateObject private var motionManager = MotionManager()
    
    var body: some View {
        VStack() {
            Spacer()
            
            HStack {
                VStack {
                    Text("Goal")
                        .font(.system(size: 20, weight: .medium ))
                    Text("\(goal) ml")
                        .font(.title3)
                }
                Spacer()
                VStack {
                    Text("Progress")
                        .font(.system(size: 20, weight: .medium ))
                    Text("\(Int(progress * 100))%")
                        .font(.title3)
                }
            }
            .padding(.horizontal, 60)
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                    .frame(width: 300, height: 300)
                
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 300, height: 300)
                
           
                ZStack {
                    WaterWave(offsetDeg: waveOffset1, progress: progress, waveHeight: 12, horizontalTilt: motionManager.gravityX)
                        .fill(Color.blue.opacity(0.25))
                    WaterWave(offsetDeg: waveOffset2, progress: progress + 0.01, waveHeight: 10, horizontalTilt: motionManager.gravityX)
                        .fill(Color.blue.opacity(0.35))
                    WaterWave(offsetDeg: waveOffset3, progress: progress + 0.02, waveHeight: 8, horizontalTilt: motionManager.gravityX)
                        .fill(Color.blue.opacity(0.45))
                }
                .frame(width: 600, height: 300)
                .mask(
                    Circle()
                        .frame(width: 300, height: 300)
                )
                .rotationEffect(.degrees(motionManager.gravityX * 30))
                .animation(.easeOut(duration: 0.1), value: motionManager.gravityX)
                
                Text("\(currentIntake) ml")
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
            }
            .onAppear {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                    waveOffset1 = 360
                }
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                    waveOffset2 = -360
                }
                withAnimation(Animation.linear(duration: 4).repeatForever(autoreverses: false)) {
                    waveOffset3 = 360
                }
                startReminderTimer()
            }
            
           
            Text(formatTime(seconds: timeRemaining))
                .font(.system(size: 25, weight: .medium ))
                .foregroundColor(.gray)
                .monospacedDigit()
            
            
            HStack(alignment: .bottom, spacing: 15) {
                ForEach([50,100,150,250], id: \.self) { amount in
                    VStack {
                        Image("WaterGlass")
                            .resizable()
                            .scaledToFit()
                            .frame(height: CGFloat(amount)/5 + 40)
                        Text("\(amount) ml")
                            .font(.caption)
                    }
                    .onTapGesture { agregarAgua(amount) }
                    .frame(height: 160)
                }
                
                VStack {
                    Button(action: { showCustomAmountModal = true }) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 50, height: 50)
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.blue)
                        }
                    }
                    Text("Other\namount")
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                }
                .frame(height: 160)
            }
            .padding(.horizontal, 30)
        }
        .padding(.vertical, 30)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showCustomAmountModal) {
            VStack(spacing: 20) {
                Text("Add Custom Amount")
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)
                
                TextField("Enter amount in ml", text: $customAmount)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 30)
                
                HStack(spacing: 20) {
                    Button("Cancel") {
                        customAmount = ""
                        showCustomAmountModal = false
                    }
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button("Add") {
                        if let amount = Int(customAmount), amount > 0 {
                            agregarAgua(amount)
                            customAmount = ""
                            showCustomAmountModal = false
                        }
                    }
                    .foregroundColor(.blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
            .presentationDetents([.height(250)])
        }
    }
    
    
    func startReminderTimer() {
        timeRemaining = reminderInterval * 60
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                print("¡Hora de beber agua!")
                timeRemaining = reminderInterval * 60
            }
        }
    }
    
    func formatTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }
    
    func agregarAgua(_ cantidad: Int) {
        currentIntake += cantidad
        
        let newProgress = CGFloat(currentIntake) / CGFloat(goal)
        withAnimation(.easeInOut(duration: 0.6)) {
            progress = min(newProgress, 1.0)
        }
        
        startReminderTimer()
    }
}


struct WaterWave: Shape {
    var offsetDeg: Double
    var progress: CGFloat
    var waveHeight: CGFloat
    var horizontalTilt: Double = 0.0

    var animatableData: Double {
        get { offsetDeg }
        set { offsetDeg = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let waveLength = rect.width / 1.5
        let baseHeight = rect.height * (1 - progress)
        let offsetRad = CGFloat(offsetDeg * .pi / 180)
        let tiltOffset = CGFloat(horizontalTilt) * 150  

        path.move(to: CGPoint(x: 0, y: baseHeight))

        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX = x / waveLength
            let y = waveHeight * sin(relativeX * .pi * 2 + offsetRad) + baseHeight
            path.addLine(to: CGPoint(x: x + tiltOffset, y: y))
        }

        path.addLine(to: CGPoint(x: rect.width + CGFloat(tiltOffset), y: rect.height))
        path.addLine(to: CGPoint(x: 0 + CGFloat(tiltOffset), y: rect.height))
        path.closeSubpath()

        return path
    }
}


#Preview {
    MainPageView(goal: 1955, reminderInterval: 30)
}

