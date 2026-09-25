import XCTest
import Capacitor
@testable import DeviceSecurityDetectPlugin

class DeviceSecurityDetectTests: XCTestCase {
    func testSimulatorIsNotJailbroken() throws {
        #if !targetEnvironment(simulator)
        throw XCTSkip("The jailbreak checks are only skipped on a simulator")
        #endif

        XCTAssertFalse(DeviceSecurityDetect().isJailBreak())
    }

    func testMethodTable() {
        let plugin = DeviceSecurityDetectPlugin()

        XCTAssertEqual(plugin.jsName, "DeviceSecurityDetect")
        XCTAssertEqual(plugin.pluginMethods.map(\.name), ["isJailBreakOrRooted", "pinCheck"])
        XCTAssertTrue(plugin.pluginMethods.allSatisfy { $0.returnType == .promise })
    }

    @MainActor
    func testIsJailBreakOrRootedReturnsTheValue() async throws {
        #if !targetEnvironment(simulator)
        throw XCTSkip("The jailbreak checks are only skipped on a simulator")
        #endif

        let call = CAPPluginCall(callbackId: "test", methodName: "isJailBreakOrRooted", options: [:], success: { _, _ in
            XCTFail("isJailBreakOrRooted answers by returning")
        }, error: { _ in
            XCTFail("isJailBreakOrRooted does not reject")
        })
        let result = await DeviceSecurityDetectPlugin().isJailBreakOrRooted(call)
        XCTAssertEqual(result["value"] as? Bool, false)
    }
}
