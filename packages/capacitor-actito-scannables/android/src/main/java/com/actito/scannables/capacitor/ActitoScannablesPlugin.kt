package com.actito.scannables.capacitor

import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin
import com.actito.Actito
import com.actito.ActitoCallback
import com.actito.scannables.ActitoScannables
import com.actito.scannables.ktx.scannables
import com.actito.scannables.models.ActitoScannable

@CapacitorPlugin(name = "ActitoScannablesPlugin")
public class ActitoScannablesPlugin : Plugin(), ActitoScannables.ScannableSessionListener {
    override fun load() {
        logger.hasDebugLoggingEnabled = Actito.options?.debugLoggingEnabled ?: false

        EventBroker.setup(this::notifyListeners)

        Actito.scannables().removeListener(this)
        Actito.scannables().addListener(this)
    }

    @PluginMethod
    public fun canStartNfcScannableSession(call: PluginCall) {
        call.resolve(JSObject().apply {
            put("result", Actito.scannables().canStartNfcScannableSession)
        })
    }

    @PluginMethod
    public fun startScannableSession(call: PluginCall) {
        val activity = activity ?: run {
            call.reject("Cannot start a scannable session without an activity.")
            return
        }

        Actito.scannables().startScannableSession(activity)
        call.resolve()
    }

    @PluginMethod
    public fun startNfcScannableSession(call: PluginCall) {
        val activity = activity ?: run {
            call.reject("Cannot start a scannable session without an activity.")
            return
        }

        Actito.scannables().startNfcScannableSession(activity)
        call.resolve()
    }

    @PluginMethod
    public fun startQrCodeScannableSession(call: PluginCall) {
        val activity = activity ?: run {
            call.reject("Cannot start a scannable session without an activity.")
            return
        }

        Actito.scannables().startQrCodeScannableSession(activity)
        call.resolve()
    }

    @PluginMethod
    public fun fetch(call: PluginCall) {
        val tag = call.getString("tag") ?: run {
            call.reject("Missing 'tag' parameter.")
            return
        }

        Actito.scannables().fetch(tag, object : ActitoCallback<ActitoScannable> {
            override fun onSuccess(result: ActitoScannable) {
                try {
                    call.resolve(
                        JSObject().apply {
                            put("result", result.toJson())
                        }
                    )
                } catch (e: Exception) {
                    call.reject(e.localizedMessage)
                }
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    // region ActitoScannables.ScannableSessionListener

    override fun onScannableDetected(scannable: ActitoScannable) {
        try {
            EventBroker.dispatchEvent("scannable_detected", scannable.toJson())
        } catch (e: Exception) {
            logger.error("Failed to emit the scannable_detected event.", e)
        }
    }

    override fun onScannableSessionError(error: Exception) {
        try {
            EventBroker.dispatchEvent("scannable_session_failed", JSObject().apply {
                put("error", error.localizedMessage)
            })
        } catch (e: Exception) {
            logger.error("Failed to emit the scannable_session_failed event.", e)
        }
    }

    // endregion
}
