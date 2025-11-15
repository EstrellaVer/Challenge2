//
//  Color.swift
//  challenge2.2
//
//  Created by Estrella Verdiguel on 08/11/25.
//

import SwiftUI

extension Color {
    /// Permite inicializar un color desde un código hexadecimal
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

extension Color {
    static let waterBackground = Color(hex: "#7DD1FB")
    static let waveLight = Color(hex: "#6AC1F9")
    static let waveMedium = Color(hex: "#6AC2FE")
    static let waveDark = Color(hex: "#56B3F8")
    static let textPrimary = Color.white
}


