package dev.wisamidris77.flux

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "dev.wisamidris77.flux/launcher_icon"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "changeIcon" -> {
                    val iconName = call.argument<String>("iconName")
                    if (iconName != null) {
                        val success = changeLauncherIcon(iconName)
                        if (success) {
                            result.success(true)
                        } else {
                            result.error("ERROR", "Failed to change launcher icon", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "iconName is null", null)
                    }
                }
                "getCurrentIcon" -> {
                    result.success(getCurrentLauncherIcon())
                }
                "isThemedIconEnabled" -> {
                    result.success(isThemedIconEnabled())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private val aliases = listOf(
        "Azure", "Violet", "Sunset", "Ruby", "Graphite", "Amber", "Blossom"
    )

    private fun changeLauncherIcon(targetName: String): Boolean {
        val pm = packageManager
        val packageName = packageName

        // If the target is Emerald, enable the main activity and disable all other aliases
        if (targetName.lowercase() == "emerald") {
            val mainComp = ComponentName(packageName, "$packageName.MainActivity")
            pm.setComponentEnabledSetting(
                mainComp,
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                PackageManager.DONT_KILL_APP
            )
            for (alias in aliases) {
                val compName = ComponentName(packageName, "$packageName.MainActivity$alias")
                pm.setComponentEnabledSetting(
                    compName,
                    PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                    PackageManager.DONT_KILL_APP
                )
            }
            return true
        }

        // If the target is an alias, enable it, disable other aliases, and disable main activity
        var found = false
        for (alias in aliases) {
            val compName = ComponentName(packageName, "$packageName.MainActivity$alias")
            if (alias.lowercase() == targetName.lowercase()) {
                pm.setComponentEnabledSetting(
                    compName,
                    PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                    PackageManager.DONT_KILL_APP
                )
                found = true
            } else {
                pm.setComponentEnabledSetting(
                    compName,
                    PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                    PackageManager.DONT_KILL_APP
                )
            }
        }

        if (found) {
            // Disable main activity
            val mainComp = ComponentName(packageName, "$packageName.MainActivity")
            pm.setComponentEnabledSetting(
                mainComp,
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP
            )
        }
        return found
    }

    private fun getCurrentLauncherIcon(): String {
        val pm = packageManager
        val packageName = packageName
        
        // If main activity is enabled, current icon is Emerald (default)
        val mainComp = ComponentName(packageName, "$packageName.MainActivity")
        val mainState = pm.getComponentEnabledSetting(mainComp)
        if (mainState == PackageManager.COMPONENT_ENABLED_STATE_ENABLED || 
            mainState == PackageManager.COMPONENT_ENABLED_STATE_DEFAULT) {
            return "Emerald"
        }

        for (alias in aliases) {
            val compName = ComponentName(packageName, "$packageName.MainActivity$alias")
            val state = pm.getComponentEnabledSetting(compName)
            if (state == PackageManager.COMPONENT_ENABLED_STATE_ENABLED) {
                return alias
            }
        }
        return "Emerald"
    }

    private fun isThemedIconEnabled(): Boolean {
        return try {
            val enabled = android.provider.Settings.Secure.getInt(
                contentResolver,
                "themed_icon_enabled",
                0
            )
            enabled == 1
        } catch (e: Exception) {
            false
        }
    }
}
