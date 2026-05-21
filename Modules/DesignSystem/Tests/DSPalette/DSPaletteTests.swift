import Foundation
import SwiftUI
import Testing
@testable import DesignSystem

@Suite struct DSPaletteTests {
    @Test func resolvedForLightSchemeReturnsLightPalette() {
        #expect(DSPalette.resolved(for: .light) == .light)
    }

    @Test func resolvedForDarkSchemeReturnsDarkPalette() {
        #expect(DSPalette.resolved(for: .dark) == .dark)
    }

    @Test func lightBackgroundIsWhite() {
        let (r, g, b) = rgb(DSPalette.light.background)
        #expect(r == 255 && g == 255 && b == 255)
    }

    @Test func darkBackgroundIsBlack() {
        let (r, g, b) = rgb(DSPalette.dark.background)
        #expect(r == 0 && g == 0 && b == 0)
    }

    @Test func lightSurfaceMatchesMockup() {
        let (r, g, b) = rgb(DSPalette.light.surface)
        #expect(r == 0xF2 && g == 0xF2 && b == 0xF7)
    }

    @Test func darkSurfaceMatchesMockup() {
        let (r, g, b) = rgb(DSPalette.dark.surface)
        #expect(r == 0x1C && g == 0x1C && b == 0x1E)
    }

    @Test func environmentReturnsCorrectPaletteForScheme() {
        var lightEnv = EnvironmentValues()
        lightEnv.colorScheme = .light
        #expect(lightEnv.dsPalette == .light)

        var darkEnv = EnvironmentValues()
        darkEnv.colorScheme = .dark
        #expect(darkEnv.dsPalette == .dark)
    }

    // MARK: - Helpers

    private func rgb(_ color: Color) -> (Int, Int, Int) {
        let resolved = color.resolve(in: EnvironmentValues())
        return (
            Int(round(resolved.red * 255)),
            Int(round(resolved.green * 255)),
            Int(round(resolved.blue * 255))
        )
    }
}
