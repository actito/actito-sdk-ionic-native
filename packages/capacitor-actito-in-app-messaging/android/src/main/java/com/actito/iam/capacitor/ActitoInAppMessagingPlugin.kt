package com.actito.iam.capacitor

import android.os.Handler
import android.os.Looper
import com.actito.Actito
import com.actito.iam.ActitoInAppMessaging
import com.actito.iam.ktx.inAppMessaging
import com.actito.iam.models.ActitoInAppMessage
import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin

@CapacitorPlugin(name = "ActitoInAppMessagingPlugin")
public class ActitoInAppMessagingPlugin : Plugin(), ActitoInAppMessaging.MessageLifecycleListener {

    override fun load() {
        logger.hasDebugLoggingEnabled = Actito.options?.debugLoggingEnabled ?: false

        EventBroker.setup(this::notifyListeners)

        Actito.inAppMessaging().removeLifecycleListener(this)
        Actito.inAppMessaging().addLifecycleListener(this)
    }

    // region Actito In-App Messaging

    @PluginMethod
    public fun hasMessagesSuppressed(call: PluginCall) {
        try {
            call.resolve(
                JSObject().apply {
                    put("result", Actito.inAppMessaging().hasMessagesSuppressed)
                }
            )
        } catch (e: Exception) {
            call.reject(e.localizedMessage)
        }
    }

    @PluginMethod
    public fun setMessagesSuppressed(call: PluginCall) {
        try {
            val suppressed = call.getBoolean("suppressed") ?: run {
                call.reject("Missing 'product' parameter.")
                return
            }

            val evaluateContext = call.getBoolean("evaluateContext") ?: false

            Actito.inAppMessaging().setMessagesSuppressed(suppressed, evaluateContext)

            call.resolve()
        } catch (e: Exception) {
            call.reject(e.localizedMessage)
        }
    }

    // region ActitoInAppMessaging.MessageLifecycleListener

    override fun onMessagePresented(message: ActitoInAppMessage) {
        try {
            val data = JSObject().apply {
                put("message", message.toJson())
            }

            EventBroker.dispatchEvent("message_presented", data)
        } catch (e: Exception) {
            logger.error("Failed to emit the message_presented event.", e)
        }
    }

    override fun onMessageFinishedPresenting(message: ActitoInAppMessage) {
        try {
            val data = JSObject().apply {
                put("message", message.toJson())
            }

            EventBroker.dispatchEvent("message_finished_presenting", data)
        } catch (e: Exception) {
            logger.error("Failed to emit the message_finished_presenting event.", e)
        }
    }

    override fun onMessageFailedToPresent(message: ActitoInAppMessage) {
        try {
            val data = JSObject().apply {
                put("message", message.toJson())
            }

            EventBroker.dispatchEvent("message_failed_to_present", data)
        } catch (e: Exception) {
            logger.error("Failed to emit the message_failed_to_present event.", e)
        }
    }

    override fun onActionExecuted(message: ActitoInAppMessage, action: ActitoInAppMessage.Action) {
        try {
            val data = JSObject().apply {
                put("message", message.toJson())
                put("action", action.toJson())
            }

            EventBroker.dispatchEvent("action_executed", data)
        } catch (e: Exception) {
            logger.error("Failed to emit the action_executed event.", e)
        }
    }

    override fun onActionFailedToExecute(
        message: ActitoInAppMessage,
        action: ActitoInAppMessage.Action,
        error: Exception?
    ) {
        try {
            val data = JSObject().apply {
                put("message", message.toJson())
                put("action", action.toJson())
            }

            if (error != null) {
                data.put("error", error.message)
            }

            EventBroker.dispatchEvent("action_failed_to_execute", data)
        } catch (e: Exception) {
            logger.error("Failed to emit the action_failed_to_execute event.", e)
        }
    }

    // endregion

    // endregion

    public companion object {
        internal fun onMainThread(action: () -> Unit) = Handler(Looper.getMainLooper()).post(action)
    }
}
