//
//  ContentView.swift
//  challenge2.2
//
//  Created by Estrella Verdiguel on 06/11/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var waveOffset = Angle(degrees: 0)
    @State private var waveOffset2 = Angle(degrees: 0)
    @State private var showRegister = false
    
    var body: some View {
        ZStack {
            if showRegister {
                RegisterView()
                    .transition(.opacity)
            } else {
                splashView
                    .transition(.opacity)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                waveOffset = Angle(degrees: 360)
                waveOffset2 = Angle(degrees: -360)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    showRegister = true
                }
            }
        }
    }
    
    var splashView: some View {
        ZStack {
            Color.waterBackground
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Spacer()
                
                ZStack {
                    Image("Icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.white)
                }
                
                Text("WATER TRACKER.")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundStyle(Color.white)
                    .padding(.top, 20)
                
                Spacer()
                
                ZStack {
                    WaveShape(offset: Angle(degrees: waveOffset.degrees))
                        .fill(Color(red: 0.42, green: 0.74, blue: 0.96))
                        .frame(height: 100)
                        .opacity(0.7)
                        .offset(y: 0)
                    
                    WaveShape(offset: Angle(degrees: waveOffset2.degrees + 180))
                        .fill(Color(red: 0.35, green: 0.67, blue: 0.94))
                        .frame(height: 100)
                        .opacity(0.6)
                        .offset(y: 30)
                    
                    WaveShape(offset: Angle(degrees: waveOffset.degrees + 20))
                        .fill(Color(red: 0.30, green: 0.62, blue: 0.91))
                        .frame(height: 150)
                        .opacity(0.8)
                        .offset(y: 60)
                }
                .frame(height: 200)
            }
        }
    }
}


struct WaveShape: Shape {
    var offset: Angle
    
    var animatableData: Angle.AnimatableData {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let waveHeight: CGFloat = 20
        let wavelength = rect.width / 1.5

        path.move(to: CGPoint(x: 0, y: rect.midY))

        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX = x / wavelength
            let sine = sin(relativeX * .pi * 2 + CGFloat(offset.radians))
            let y = rect.midY + sine * waveHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ContentView()
}

