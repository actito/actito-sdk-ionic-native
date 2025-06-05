package com.actito.inbox.capacitor

import android.os.Handler
import android.os.Looper
import androidx.lifecycle.Observer
import com.getcapacitor.*
import com.getcapacitor.annotation.CapacitorPlugin
import com.actito.Actito
import com.actito.ActitoCallback
import com.actito.inbox.ktx.inbox
import com.actito.inbox.models.ActitoInboxItem
import com.actito.models.ActitoNotification
import java.util.*

@CapacitorPlugin(name = "ActitoInboxPlugin")
public class ActitoInboxPlugin : Plugin() {
    private val itemsObserver = Observer<SortedSet<ActitoInboxItem>> { items ->
        if (items == null) return@Observer

        try {
            val data = JSObject()
            data.put("items", JSArray(items.map { it.toJson() }))

            EventBroker.dispatchEvent("inbox_updated", data)
        } catch (e: Exception) {
            logger.error("Failed to emit the inbox_updated event.", e)
        }
    }

    private val badgeObserver = Observer<Int> { badge ->
        if (badge == null) return@Observer

        EventBroker.dispatchEvent("badge_updated", JSObject().apply {
            put("badge", badge)
        })
    }

    override fun load() {
        logger.hasDebugLoggingEnabled = Actito.options?.debugLoggingEnabled ?: false

        EventBroker.setup(this::notifyListeners)

        onMainThread {
            Actito.inbox().observableItems.removeObserver(itemsObserver)
            Actito.inbox().observableItems.observeForever(itemsObserver)

            Actito.inbox().observableBadge.removeObserver(badgeObserver)
            Actito.inbox().observableBadge.observeForever(badgeObserver)
        }
    }

    // region Actito Inbox

    @PluginMethod
    public fun getItems(call: PluginCall) {
        try {
            call.resolve(
                JSObject().apply {
                    put("result", JSArray(Actito.inbox().items.map { it.toJson() }))
                }
            )
        } catch (e: Exception) {
            call.reject(e.localizedMessage)
        }
    }

    @PluginMethod
    public fun getBadge(call: PluginCall) {
        call.resolve(
            JSObject().apply {
                put("result", Actito.inbox().badge)
            }
        )
    }

    @PluginMethod
    public fun refresh(call: PluginCall) {
        Actito.inbox().refresh()
        call.resolve()
    }

    @PluginMethod
    public fun open(call: PluginCall) {
        val json = call.getObject("item") ?: run {
            call.reject("Missing 'item' parameter.")
            return
        }

        val item: ActitoInboxItem = try {
            ActitoInboxItem.fromJson(json)
        } catch (e: Exception) {
            call.reject(e.localizedMessage)
            return
        }

        Actito.inbox().open(item, object : ActitoCallback<ActitoNotification> {
            override fun onSuccess(result: ActitoNotification) {
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

    @PluginMethod
    public fun markAsRead(call: PluginCall) {
        val json = call.getObject("item") ?: run {
            call.reject("Missing 'item' parameter.")
            return
        }

        val item: ActitoInboxItem = try {
            ActitoInboxItem.fromJson(json)
        } catch (e: Exception) {
            call.reject(e.localizedMessage)
            return
        }

        Actito.inbox().markAsRead(item, object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun markAllAsRead(call: PluginCall) {
        Actito.inbox().markAllAsRead(object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun remove(call: PluginCall) {
        val json = call.getObject("item") ?: run {
            call.reject("Missing 'item' parameter.")
            return
        }

        val item: ActitoInboxItem = try {
            ActitoInboxItem.fromJson(json)
        } catch (e: Exception) {
            call.reject(e.localizedMessage)
            return
        }

        Actito.inbox().remove(item, object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun clear(call: PluginCall) {
        Actito.inbox().clear(object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    // endregion

    public companion object {
        internal fun onMainThread(action: () -> Unit) = Handler(Looper.getMainLooper()).post(action)
    }
}
