package com.actito.inbox.user.capacitor

import com.actito.Actito
import com.actito.ActitoCallback
import com.actito.inbox.user.ktx.userInbox
import com.actito.inbox.user.models.ActitoUserInboxItem
import com.actito.models.ActitoNotification
import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin


@CapacitorPlugin(name = "ActitoUserInboxPlugin")
public class ActitoUserInboxPlugin : Plugin() {
    @PluginMethod
    public fun parseResponseFromJson(call: PluginCall) {
        val json = call.getObject("json") ?: run {
            call.reject("Missing 'json' parameter.")
            return
        }

        try {
            val response = Actito.userInbox().parseResponse(json)
            call.resolve(
                JSObject().apply {
                    put("result", response.toJson())
                }
            )
        } catch (e: Exception) {
            call.reject(e.localizedMessage)
        }
    }

    @PluginMethod
    public fun parseResponseFromString(call: PluginCall) {
        val json = call.getString("json") ?: run {
            call.reject("Missing 'json' parameter.")
            return
        }

        try {
            val response = Actito.userInbox().parseResponse(json)
            call.resolve(
                JSObject().apply {
                    put("result", response.toJson())
                }
            )
        } catch (e: Exception) {
            call.reject(e.localizedMessage)
        }
    }

    @PluginMethod
    public fun open(call: PluginCall) {
        val json = call.getObject("item") ?: run {
            call.reject("Missing 'item' parameter.")
            return
        }

        val item: ActitoUserInboxItem = try {
            ActitoUserInboxItem.fromJson(json)
        } catch (e: Exception) {
            call.reject(e.localizedMessage)
            return
        }

        Actito.userInbox().open(item, object : ActitoCallback<ActitoNotification> {
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

        val item: ActitoUserInboxItem = try {
            ActitoUserInboxItem.fromJson(json)
        } catch (e: Exception) {
            call.reject(e.localizedMessage)
            return
        }

        Actito.userInbox().markAsRead(item, object : ActitoCallback<Unit> {
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

        val item: ActitoUserInboxItem = try {
            ActitoUserInboxItem.fromJson(json)
        } catch (e: Exception) {
            call.reject(e.localizedMessage)
            return
        }

        Actito.userInbox().remove(item, object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }
}
