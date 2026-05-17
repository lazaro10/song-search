import Foundation
import SwiftUI
import Testing
@testable import DesignSystem

@Suite struct ColorHexTests {
    @Test func parsesSixDigitHexWithLeadingHash() {
        let (r, g, b, _) = rgbaComponents(Color(hex: "#6E45D6"))
        #expect(r == 0x6E)
        #expect(g == 0x45)
        #expect(b == 0xD6)
    }

    @Test func parsesSixDigitHexWithoutLeadingHash() {
        let (r, g, b, _) = rgbaComponents(Color(hex: "F0795F"))
        #expect(r == 0xF0)
        #expect(g == 0x79)
        #expect(b == 0x5F)
    }

    @Test func returnsClearForInvalidLength() {
        let (_, _, _, a) = rgbaComponents(Color(hex: "#ABC"))
        #expect(a == 0)
    }

    @Test func returnsClearForNonHexCharacters() {
        let (_, _, _, a) = rgbaComponents(Color(hex: "#ZZZZZZ"))
        #expect(a == 0)
    }

    // MARK: - Helpers

    private func rgbaComponents(_ color: Color) -> (Int, Int, Int, Int) {
        let resolved = color.resolve(in: EnvironmentValues())
        return (
            Int(round(resolved.red * 255)),
            Int(round(resolved.green * 255)),
            Int(round(resolved.blue * 255)),
            Int(round(resolved.opacity * 255))
        )
    }
}
