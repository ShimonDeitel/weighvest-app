import SwiftUI

enum Theme {
    static let background = Color(hex: "#1B1F1C")
    static let foreground = Color(hex: "#E9EDE9")
    static let accent = Color(hex: "#7FA37A")
    static let accentSecondary = Color(hex: "#C9A24B")

    static var titleFont: Font { .system(.title2, design: .rounded).weight(.bold) }
    static var bodyFont: Font { .system(.body, design: .rounded) }
    static var captionFont: Font { .system(.caption, design: .rounded) }
}

extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        let r = Double((v >> 16) & 0xFF) / 255.0
        let g = Double((v >> 8) & 0xFF) / 255.0
        let b = Double(v & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
