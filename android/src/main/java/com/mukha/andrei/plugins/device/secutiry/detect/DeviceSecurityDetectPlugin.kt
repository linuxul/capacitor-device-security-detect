package com.mukha.andrei.plugins.device.secutiry.detect

import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin

@CapacitorPlugin(name = "DeviceSecurityDetect")
public class DeviceSecurityDetectPlugin : Plugin() {
    private val implementation = DeviceSecurityDetect()

    @PluginMethod
    public fun isJailBreakOrRooted(call: PluginCall) {
        val isDeviceRooted = implementation.isDeviceRooted()

        val ret = JSObject()
        ret.put("value", isDeviceRooted)
        call.resolve(ret)
    }

    @PluginMethod
    public fun pinCheck(call: PluginCall) {
        val ret = JSObject()
        ret.put("value", implementation.pinCheck(context))
        call.resolve(ret)
    }
}
