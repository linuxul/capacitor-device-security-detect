import Foundation
import Capacitor

@objc(DeviceSecurityDetectPlugin)
public class DeviceSecurityDetectPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "DeviceSecurityDetectPlugin"
    public let jsName = "DeviceSecurityDetect"
    public let pluginMethods: [CAPPluginMethod] = [
        .async("isJailBreakOrRooted", DeviceSecurityDetectPlugin.isJailBreakOrRooted),
        .promise("pinCheck", DeviceSecurityDetectPlugin.pinCheck)
    ]
    private let implementation = DeviceSecurityDetect()

    /// Returns `{ value }`. One of the checks asks UIApplication whether it can open `cydia://`, and UIApplication is
    /// main-thread API, so the method runs on the main actor.
    @MainActor
    func isJailBreakOrRooted(_ call: CAPPluginCall) async -> JSObject {
        log("Checking if device is jailbroken from plugin")
        return [
            "value": implementation.isJailBreak()
        ]
    }

    func pinCheck(_ call: CAPPluginCall) {
        log("Checking PIN status from plugin")
        call.resolve([
            "value": implementation.pinCheck()
        ])
    }
}
