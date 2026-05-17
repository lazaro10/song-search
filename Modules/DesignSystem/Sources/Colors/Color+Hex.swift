import SwiftUI

public extension Color {
    init(hex: String) {
        let trimmed = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        guard trimmed.count == 6, let value = UInt32(trimmed, radix: 16) else {
            self = .clear
            return
        }
        let red = Double((value & 0xFF0000) >> 16) / 255
        let green = Double((value & 0x00FF00) >> 8) / 255
        let blue = Double(value & 0x0000FF) / 255
        self.init(red: red, green: green, blue: blue)
    }
}
