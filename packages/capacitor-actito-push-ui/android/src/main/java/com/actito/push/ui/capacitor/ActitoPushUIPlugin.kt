package com.actito.push.ui.capacitor

import android.net.Uri
import com.actito.Actito
import com.actito.models.ActitoNotification
import com.actito.push.ui.ActitoPushUI
import com.actito.push.ui.ktx.pushUI
import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin

@CapacitorPlugin(name = "ActitoPushUIPlugin")
public class ActitoPushUIPlugin : Plugin(), ActitoPushUI.NotificationLifecycleListener {
    override fun load() {
        logger.hasDebugLoggingEnabled = Actito.options?.debugLoggingEnabled ?: false

        // Make sure the listener isn't added in duplicate.
        Actito.pushUI().removeLifecycleListener(this)

        EventBroker.setup(this::notifyListeners)
        Actito.pushUI().addLifecycleListener(this)
    }

    // region Actito Push UI

    @PluginMethod
    public fun presentNotification(call: PluginCall) {
        val data = call.getObject("notification") ?: run {
            call.reject("Missing 'notification' parameter.")
            return
        }

        val notification: ActitoNotification

        try {
            notification = ActitoNotification.fromJson(data)
        } catch (e: Exception) {
            call.reject(e.localizedMessage)
            return
        }

        val activity = activity ?: run {
            call.reject("Cannot present a notification without an activity.")
            return
        }

        Actito.pushUI().presentNotification(activity, notification)
        call.resolve()
    }

    @PluginMethod
    public fun presentAction(call: PluginCall) {
        val notificationData = call.getObject("notification") ?: run {
            call.reject("Missing 'notification' parameter.")
            return
        }

        val actionData = call.getObject("action") ?: run {
            call.reject("Missing 'action' parameter.")
            return
        }


        val notification: ActitoNotification
        val action: ActitoNotification.Action

        try {
            notification = ActitoNotification.fromJson(notificationData)
            action = ActitoNotification.Action.fromJson(actionData)
        } catch (e: Exception) {
            call.reject(e.localizedMessage)
            return
        }

        val activity = activity ?: run {
            call.reject("Cannot present a notification action without an activity.")
            return
        }

        Actito.pushUI().presentAction(activity, notification, action)
        call.resolve()
    }

    // region ActitoPushUI.NotificationLifecycleListener

    override fun onNotificationWillPresent(notification: ActitoNotification) {
        try {
            EventBroker.dispatchEvent("notification_will_present", notification.toJson())
        } catch (e: Exception) {
            logger.error("Failed to emit the notification_will_present event.", e)
        }
    }

    override fun onNotificationPresented(notification: ActitoNotification) {
        try {
            EventBroker.dispatchEvent("notification_presented", notification.toJson())
        } catch (e: Exception) {
            logger.error("Failed to emit the notification_presented event.", e)
        }
    }

    override fun onNotificationFinishedPresenting(notification: ActitoNotification) {
        try {
            EventBroker.dispatchEvent("notification_finished_presenting", notification.toJson())
        } catch (e: Exception) {
            logger.error("Failed to emit the notification_finished_presenting event.", e)
        }
    }

    override fun onNotificationFailedToPresent(notification: ActitoNotification) {
        try {
            EventBroker.dispatchEvent("notification_failed_to_present", notification.toJson())
        } catch (e: Exception) {
            logger.error("Failed to emit the notification_failed_to_present event.", e)
        }
    }

    override fun onNotificationUrlClicked(notification: ActitoNotification, uri: Uri) {
        try {
            val data = JSObject()
            data.put("notification", notification.toJson())
            data.put("url", uri.toString())

            EventBroker.dispatchEvent("notification_url_clicked", data)
        } catch (e: Exception) {
            logger.error("Failed to emit the notification_url_clicked event.", e)
        }
    }

    override fun onActionWillExecute(notification: ActitoNotification, action: ActitoNotification.Action) {
        try {
            val data = JSObject()
            data.put("notification", notification.toJson())
            data.put("action", action.toJson())

            EventBroker.dispatchEvent("action_will_execute", data)
        } catch (e: Exception) {
            logger.error("Failed to emit the action_will_execute event.", e)
        }
    }

    override fun onActionExecuted(notification: ActitoNotification, action: ActitoNotification.Action) {
        try {
            val data = JSObject()
            data.put("notification", notification.toJson())
            data.put("action", action.toJson())

            EventBroker.dispatchEvent("action_executed", data)
        } catch (e: Exception) {
            logger.error("Failed to emit the action_executed event.", e)
        }
    }

    override fun onActionFailedToExecute(
        notification: ActitoNotification,
        action: ActitoNotification.Action,
        error: Exception?,
    ) {
        try {
            val data = JSObject()
            data.put("notification", notification.toJson())
            data.put("action", action.toJson())
            if (error != null) data.put("error", error.localizedMessage)

            EventBroker.dispatchEvent("action_failed_to_execute", data)
        } catch (e: Exception) {
            logger.error("Failed to emit the action_failed_to_execute event.", e)
        }
    }

    override fun onCustomActionReceived(
        notification: ActitoNotification,
        action: ActitoNotification.Action,
        uri: Uri
    ) {
        try {
            val data = JSObject()
            data.put("notification", notification.toJson())
            data.put("action", action.toJson())
            data.put("url", uri.toString())

            EventBroker.dispatchEvent("custom_action_received", data)
        } catch (e: Exception) {
            logger.error("Failed to emit the custom_action_received event.", e)
        }
    }

    // endregion
}
