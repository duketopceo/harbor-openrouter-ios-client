import SwiftUI

enum HarborDesign {
    enum Color {
        static let canvas = Color(hex: 0x000000)
        static let surface = Color(hex: 0x111111)
        static let surfaceElevated = Color(hex: 0x1a1a1a)
        static let text = Color(hex: 0xffffff)
        static let body = Color(hex: 0xd4d4d4)
        static let muted = Color(hex: 0x9ca3af)
        static let faint = Color(hex: 0x6b7280)
        static let border = Color(hex: 0x1f1f1f)
        static let borderStrong = Color(hex: 0x2a2a2a)
        static let onBrand = Color(hex: 0x000000)
        static let success = Color(hex: 0x22c55e)
        static let danger = Color(hex: 0xef4444)
        static let warning = Color(hex: 0xfbbf24)
        static let info = Color(hex: 0x3b82f6)
    }

    enum Typography {
        static let display = Font.system(size: 28, weight: .semibold, design: .default)
        static let title = Font.system(size: 20, weight: .semibold, design: .default)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let caption = Font.system(size: 13, weight: .regular, design: .default)
        static let mono = Font.system(size: 13, weight: .regular, design: .monospaced)
    }
}

extension Color {
    init(hex: UInt) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: 1
        )
    }
}
