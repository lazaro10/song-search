import XCTest

final class SongSearchUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        // Home appears after the 1.5s splash; allow extra time for the transition.
        XCTAssertTrue(app.staticTexts["Songs"].waitForExistence(timeout: 8))
    }
}
