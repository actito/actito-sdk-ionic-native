package com.actito.push.capacitor

import android.content.Context
import com.getcapacitor.JSObject
import com.actito.models.ActitoNotification
import com.actito.push.ActitoPushIntentReceiver
import com.actito.push.models.ActitoNotificationDeliveryMechanism
import com.actito.push.models.ActitoSystemNotification
import com.actito.push.models.ActitoUnknownNotification

internal class ActitoPushPluginIntentReceiver : ActitoPushIntentReceiver() {

    override fun onNotificationReceived(
        context: Context,
        notification: ActitoNotification,
        deliveryMechanism: ActitoNotificationDeliveryMechanism
    ) {
        try {
            val data = JSObject()
            data.put("notification", notification.toJson())
            data.put("deliveryMechanism", deliveryMechanism.rawValue)

            EventBroker.dispatchEvent("notification_info_received", data)
        } catch (e: Exception) {
            logger.error("Failed to emit the notification_info_received event.", e)
        }
    }

    override fun onSystemNotificationReceived(context: Context, notification: ActitoSystemNotification) {
        try {
            EventBroker.dispatchEvent("system_notification_received", notification.toJson())
        } catch (e: Exception) {
            logger.error("Failed to emit the system_notification_received event.", e)
        }
    }

    override fun onUnknownNotificationReceived(context: Context, notification: ActitoUnknownNotification) {
        try {
            EventBroker.dispatchEvent("unknown_notification_received", notification.toJson())
        } catch (e: Exception) {
            logger.error("Failed to emit the unknown_notification_received event.", e)
        }
    }

    override fun onNotificationOpened(context: Context, notification: ActitoNotification) {
        try {
            EventBroker.dispatchEvent("notification_opened", notification.toJson())
        } catch (e: Exception) {
            logger.error("Failed to emit the notification_opened event.", e)
        }
    }

    override fun onActionOpened(
        context: Context,
        notification: ActitoNotification,
        action: ActitoNotification.Action
    ) {
        try {
            val data = JSObject()
            data.put("notification", notification.toJson())
            data.put("action", action.toJson())

            EventBroker.dispatchEvent("notification_action_opened", data)
        } catch (e: Exception) {
            logger.error("Failed to emit the notification_action_opened event.", e)
        }
    }
}
