package com.actito.capacitor

import android.content.Intent
import android.net.Uri
import com.actito.Actito
import com.actito.ActitoCallback
import com.actito.ktx.device
import com.actito.ktx.events
import com.actito.models.ActitoApplication
import com.actito.models.ActitoDoNotDisturb
import com.actito.models.ActitoDynamicLink
import com.actito.models.ActitoEvent
import com.actito.models.ActitoEventData
import com.actito.models.ActitoNotification
import com.actito.models.ActitoUserData
import com.getcapacitor.JSArray
import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin
import org.json.JSONObject

@CapacitorPlugin(name = "ActitoPlugin")
public class ActitoPlugin : Plugin() {
    override fun load() {
        logger.hasDebugLoggingEnabled = Actito.options?.debugLoggingEnabled ?: false

        EventBroker.setup(this::notifyListeners)
        Actito.intentReceiver = ActitoPluginIntentReceiver::class.java

        val intent = activity?.intent
        if (intent != null) handleOnNewIntent(intent)
    }

    override fun handleOnNewIntent(intent: Intent) {
        // Try handling the test device intent.
        if (Actito.handleTestDeviceIntent(intent)) return

        // Try handling the dynamic link intent.
        val activity = activity
        if (activity != null && Actito.handleDynamicLinkIntent(activity, intent)) return

        val url = intent.data?.toString()
        if (url != null) {
            EventBroker.dispatchEvent("url_opened", JSObject().apply {
                put("url", url)
            })
        }
    }

    // region Actito

    @PluginMethod
    public fun isConfigured(call: PluginCall) {
        call.resolve(
            JSObject().apply {
                put("result", Actito.isConfigured)
            }
        )
    }

    @PluginMethod
    public fun isReady(call: PluginCall) {
        call.resolve(
            JSObject().apply {
                put("result", Actito.isReady)
            }
        )
    }

    @PluginMethod
    public fun launch(call: PluginCall) {
        Actito.launch(object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun unlaunch(call: PluginCall) {
        Actito.unlaunch(object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun getApplication(call: PluginCall) {
        call.resolve(
            JSObject().apply {
                put("result", Actito.application?.toJson())
            }
        )
    }

    @PluginMethod
    public fun fetchApplication(call: PluginCall) {
        Actito.fetchApplication(object : ActitoCallback<ActitoApplication> {
            override fun onSuccess(result: ActitoApplication) {
                call.resolve(
                    JSObject().apply {
                        put("result", result.toJson())
                    }
                )
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun fetchNotification(call: PluginCall) {
        val id = call.getString("id") ?: run {
            call.reject("Missing 'id' parameter.")
            return
        }

        Actito.fetchNotification(id, object : ActitoCallback<ActitoNotification> {
            override fun onSuccess(result: ActitoNotification) {
                call.resolve(
                    JSObject().apply {
                        put("result", result.toJson())
                    }
                )
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun fetchDynamicLink(call: PluginCall) {
        val url = call.getString("url") ?: run {
            call.reject("Missing 'url' parameter.")
            return
        }

        val uri = Uri.parse(url)

        Actito.fetchDynamicLink(uri, object : ActitoCallback<ActitoDynamicLink> {
            override fun onSuccess(result: ActitoDynamicLink) {
                call.resolve(
                    JSObject().apply {
                        put("result", result.toJson())
                    }
                )
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun canEvaluateDeferredLink(call: PluginCall) {
        Actito.canEvaluateDeferredLink(object : ActitoCallback<Boolean> {
            override fun onSuccess(result: Boolean) {
                call.resolve(
                    JSObject().apply {
                        put("result", result)
                    }
                )
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun evaluateDeferredLink(call: PluginCall) {
        Actito.evaluateDeferredLink(object : ActitoCallback<Boolean> {
            override fun onSuccess(result: Boolean) {
                call.resolve(
                    JSObject().apply {
                        put("result", result)
                    }
                )
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    // endregion

    // region Actito device module

    @PluginMethod
    public fun getCurrentDevice(call: PluginCall) {
        call.resolve(
            JSObject().apply {
                put("result", Actito.device().currentDevice?.toJson())
            }
        )
    }

    @PluginMethod
    public fun getPreferredLanguage(call: PluginCall) {
        call.resolve(
            JSObject().apply {
                put("result", Actito.device().preferredLanguage)
            }
        )
    }

    @PluginMethod
    public fun updatePreferredLanguage(call: PluginCall) {
        val language = call.getString("language")

        Actito.device().updatePreferredLanguage(language, object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun register(call: PluginCall) {
        val userId = call.getString("userId")
        val userName = call.getString("userName")

        Actito.device().register(userId, userName, object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun updateUser(call: PluginCall) {
        val userId = call.getString("userId")
        val userName = call.getString("userName")

        Actito.device().updateUser(userId, userName, object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun fetchTags(call: PluginCall) {
        Actito.device().fetchTags(object : ActitoCallback<List<String>> {
            override fun onSuccess(result: List<String>) {
                call.resolve(
                    JSObject().apply {
                        put("result", JSArray(result))
                    }
                )
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun addTag(call: PluginCall) {
        val tag = call.getString("tag") ?: run {
            call.reject("Missing 'tag' parameter.")
            return
        }

        Actito.device().addTag(tag, object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun addTags(call: PluginCall) {
        val tags = call.getArray("tags", null)?.toList<String>() ?: run {
            call.reject("Missing 'tags' parameter.")
            return
        }

        Actito.device().addTags(tags, object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun removeTag(call: PluginCall) {
        val tag = call.getString("tag") ?: run {
            call.reject("Missing 'tag' parameter.")
            return
        }

        Actito.device().removeTag(tag, object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun removeTags(call: PluginCall) {
        val tags = call.getArray("tags", null)?.toList<String>() ?: run {
            call.reject("Missing 'tags' parameter.")
            return
        }

        Actito.device().removeTags(tags, object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun clearTags(call: PluginCall) {
        Actito.device().clearTags(object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun fetchDoNotDisturb(call: PluginCall) {
        Actito.device().fetchDoNotDisturb(object : ActitoCallback<ActitoDoNotDisturb?> {
            override fun onSuccess(result: ActitoDoNotDisturb?) {
                call.resolve(
                    JSObject().apply {
                        put("result", result?.toJson())
                    }
                )
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun updateDoNotDisturb(call: PluginCall) {
        val dnd = call.getObject("dnd", null)?.let { ActitoDoNotDisturb.fromJson(it) } ?: run {
            call.reject("Missing 'dnd' parameter.")
            return
        }

        Actito.device().updateDoNotDisturb(dnd, object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun clearDoNotDisturb(call: PluginCall) {
        Actito.device().clearDoNotDisturb(object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun fetchUserData(call: PluginCall) {
        Actito.device().fetchUserData(object : ActitoCallback<ActitoUserData> {
            override fun onSuccess(result: ActitoUserData) {
                val userData = JSONObject().apply {
                    result.forEach {
                        put(it.key, it.value)
                    }
                }

                call.resolve(
                    JSObject().apply {
                        put("result", userData)
                    }
                )
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    @PluginMethod
    public fun updateUserData(call: PluginCall) {
        val json = call.getObject("userData", null) ?: run {
            call.reject("Missing 'userData' parameter.")
            return
        }

        val userData = mutableMapOf<String, String?>().apply {
            val iterator = json.keys()
            while (iterator.hasNext()) {
                val key = iterator.next()
                val value = json.getString(key)

                put(key, value)
            }
        }

        Actito.device().updateUserData(userData, object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    // endregion

    // region Actito events module

    @PluginMethod
    public fun logCustom(call: PluginCall) {
        val event = call.getString("event") ?: run {
            call.reject("Missing 'event' parameter.")
            return
        }

        val data: ActitoEventData?

        try {
            data = call.getObject("data", null)?.let { ActitoEvent.createData(it) }
        } catch (e: Exception) {
            call.reject(e.localizedMessage)
            return
        }

        Actito.events().logCustom(event, data, object : ActitoCallback<Unit> {
            override fun onSuccess(result: Unit) {
                call.resolve()
            }

            override fun onFailure(e: Exception) {
                call.reject(e.localizedMessage)
            }
        })
    }

    // endregion
}
