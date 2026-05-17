import SwiftUI

public struct DSPalette: Sendable, Equatable {
    public let background: Color
    public let surface: Color
    public let surfaceElevated: Color
    public let text: Color
    public let textSecondary: Color
    public let textTertiary: Color
    public let hairline: Color

    public static let light = DSPalette(
        background: Color(hex: "#FFFFFF"),
        surface: Color(hex: "#F2F2F7"),
        surfaceElevated: Color(hex: "#E9E9EE"),
        text: Color(hex: "#000000"),
        textSecondary: Color(hex: "#8E8E93"),
        textTertiary: Color(hex: "#C7C7CC"),
        hairline: Color(red: 60/255, green: 60/255, blue: 67/255, opacity: 0.10)
    )

    public static let dark = DSPalette(
        background: Color(hex: "#000000"),
        surface: Color(hex: "#1C1C1E"),
        surfaceElevated: Color(hex: "#2C2C2E"),
        text: Color(hex: "#FFFFFF"),
        textSecondary: Color(red: 235/255, green: 235/255, blue: 245/255, opacity: 0.6),
        textTertiary: Color(red: 235/255, green: 235/255, blue: 245/255, opacity: 0.4),
        hairline: Color(red: 1, green: 1, blue: 1, opacity: 0.09)
    )

    public static func resolved(for colorScheme: ColorScheme) -> DSPalette {
        colorScheme == .dark ? .dark : .light
    }
}

public extension EnvironmentValues {
    var dsPalette: DSPalette {
        DSPalette.resolved(for: colorScheme)
    }
}
