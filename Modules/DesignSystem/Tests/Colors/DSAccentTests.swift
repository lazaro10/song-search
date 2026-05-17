import Foundation
import Testing
@testable import DesignSystem

@Suite struct DSAccentTests {
    @Test func allCasesContainsThreeAccents() {
        #expect(DSAccent.allCases.count == 3)
        #expect(Set(DSAccent.allCases) == [.deepPurple, .coral, .forestTeal])
    }

    @Test func rawValuesAreStableForStorage() {
        #expect(DSAccent.deepPurple.rawValue == "deepPurple")
        #expect(DSAccent.coral.rawValue == "coral")
        #expect(DSAccent.forestTeal.rawValue == "forestTeal")
    }

    @Test func labelsMatchMockup() {
        #expect(DSAccent.deepPurple.label == "Deep Purple")
        #expect(DSAccent.coral.label == "Coral")
        #expect(DSAccent.forestTeal.label == "Forest Teal")
    }

    @Test func hexesMatchMockup() {
        #expect(DSAccent.deepPurple.hex == "#6E45D6")
        #expect(DSAccent.coral.hex == "#F0795F")
        #expect(DSAccent.forestTeal.hex == "#1F9D77")
    }

    @Test func idMatchesRawValue() {
        for accent in DSAccent.allCases {
            #expect(accent.id == accent.rawValue)
        }
    }
}
