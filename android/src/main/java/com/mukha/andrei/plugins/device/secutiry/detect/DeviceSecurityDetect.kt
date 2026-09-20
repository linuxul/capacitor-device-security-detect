package com.mukha.andrei.plugins.device.secutiry.detect

import android.app.KeyguardManager
import android.content.Context
import android.os.Build
import android.util.Log
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader

public class DeviceSecurityDetect {
    public fun isDeviceRooted(): Boolean = checkBuildTags() || checkSuBinary() || isSuBinaryAvailable() || areOtaCertsMissing()

    public fun pinCheck(context: Context): Boolean {
        Log.d("DeviceSecurityDetect", "Checking if PIN or biometric authentication is enabled")
        try {
            val keyguardManager = context.getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            return keyguardManager.isKeyguardSecure
        } catch (ex: Exception) {
            Log.e("DeviceSecurityDetect", "Error checking PIN security: " + ex.message)
            return false
        }
    }

    private fun checkBuildTags(): Boolean {
        val buildTags: String? = Build.TAGS
        return buildTags != null && buildTags.contains("test-keys")
    }

    private fun checkSuBinary(): Boolean {
        val paths =
            arrayOf(
                "/system/app/Superuser.apk",
                "/sbin/su",
                "/system/bin/su",
                "/system/xbin/su",
                "/data/local/xbin/su",
                "/data/local/bin/su",
                "/system/sd/xbin/su",
                "/system/bin/failsafe/su",
                "/data/local/su",
                "/su/bin/su"
            )
        return paths.any { File(it).exists() }
    }

    private fun areOtaCertsMissing(): Boolean = !File(OTA_CERTS_PATH).exists()

    private fun isSuBinaryAvailable(): Boolean {
        var process: Process? = null
        try {
            process = Runtime.getRuntime().exec(arrayOf("/system/xbin/which", "su"))
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            return reader.readLine() != null
        } catch (t: Throwable) {
            return false
        } finally {
            process?.destroy()
        }
    }

    private companion object {
        private const val OTA_CERTS_PATH = "/etc/security/otacerts.zip"
    }
}
