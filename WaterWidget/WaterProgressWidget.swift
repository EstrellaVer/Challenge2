//
//  WaterProgressWidget.swift
//  WaterTracker
//
//  Created by Estrella Verdiguel on 15/11/25.
//

import WidgetKit
import SwiftUI


struct WaterEntry: TimelineEntry {
    let date: Date
    let progress: CGFloat
    let currentIntake: Int
    let goal: Int
    let nextDrinkTime: Date
    var timeRemaining: TimeInterval {
        max(nextDrinkTime.timeIntervalSince(date), 0)
    }
}

struct WaterWidgetView: View {
    let entry: WaterEntry
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let totalMinutes = Int(interval) / 60
        return "\(totalMinutes) min"
    }

    
    var body: some View {
        GeometryReader { geometry in
            let fullSize = min(geometry.size.width, geometry.size.height)
            let circleSize = fullSize * 0.8
            
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(Color.blue.opacity(0.3), lineWidth: circleSize * 0.05)
                    
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                    
                    WaterWave(
                        offsetDeg: 0,
                        progress: entry.progress,
                        waveHeight: circleSize * 0.05
                    )
                    .fill(Color.blue.opacity(0.45))
                    .frame(width: circleSize, height: circleSize)
                    .mask(Circle())
                    
                    
                    VStack {
                        Text("\(entry.currentIntake) ml")
                            .font(.system(size: circleSize * 0.20, weight: .bold))
                            .foregroundColor(.blue)
                        Text("\(Int(entry.progress * 100))%")
                            .font(.system(size: circleSize * 0.15))
                            .foregroundColor(.black)
                    }
                }
                
             
                Text(formatTime(entry.timeRemaining))
                    .font(.system(size: circleSize * 0.15, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .frame(width: fullSize, height: fullSize, alignment: .center)
            .padding(fullSize * 0.05)
        }
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

        path.addLine(to: CGPoint(x: rect.width + tiltOffset, y: rect.height))
        path.addLine(to: CGPoint(x: 0 + tiltOffset, y: rect.height))
        path.closeSubpath()

        return path
    }
}


struct WaterProvider: TimelineProvider {
    func placeholder(in context: Context) -> WaterEntry {
        WaterEntry(date: Date(), progress: 0.5, currentIntake: 500, goal: 1000, nextDrinkTime: Date().addingTimeInterval(3600))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WaterEntry) -> ()) {
        completion(loadEntry())
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WaterEntry>) -> ()) {
        let entry = loadEntry()

        
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!

        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }

    
    private func loadEntry() -> WaterEntry {
        let defaults = UserDefaults(suiteName: "group.com.estrellaverdiguel.watertracker")
        let currentIntake = defaults?.integer(forKey: "currentIntake") ?? 0
        let goal = defaults?.integer(forKey: "goal") ?? 1
        let progress = CGFloat(currentIntake) / CGFloat(goal)
        
        
        let nextDrinkTime = defaults?.object(forKey: "nextDrinkTime") as? Date ?? Date().addingTimeInterval(2 * 3600)
        
        return WaterEntry(
            date: Date(),
            progress: min(progress, 1.0),
            currentIntake: currentIntake,
            goal: goal,
            nextDrinkTime: nextDrinkTime
        )
    }
}


struct WaterProgressWidget: Widget {
    let kind: String = "WaterProgressWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WaterProvider()) { entry in
            WaterWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Water Tracker")
        .description("Muestra tu progreso de agua diario.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


struct WaterProgressWidget_Previews: PreviewProvider {
    static var previews: some View {
        WaterWidgetView(entry: WaterEntry(
            date: Date(),
            progress: 0.6,
            currentIntake: 600,
            goal: 1000,
            nextDrinkTime: Date().addingTimeInterval(3600)
        ))
        .containerBackground(.fill.tertiary, for: .widget)
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}



