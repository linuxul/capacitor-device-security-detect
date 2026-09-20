import XCTest
@testable import DeviceSecurityDetectPlugin

class DeviceSecurityDetectTests: XCTestCase {
    func testSimulatorIsNotJailbroken() throws {
        #if !targetEnvironment(simulator)
        throw XCTSkip("The jailbreak checks are only skipped on a simulator")
        #endif

        XCTAssertFalse(DeviceSecurityDetect().isJailBreak())
    }
}
