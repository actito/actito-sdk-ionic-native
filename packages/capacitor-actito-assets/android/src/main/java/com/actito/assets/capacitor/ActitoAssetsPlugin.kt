package com.actito.assets.capacitor

import com.actito.Actito
import com.actito.ActitoCallback
import com.actito.assets.ktx.assets
import com.actito.assets.models.ActitoAsset
import com.getcapacitor.JSArray
import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin

@CapacitorPlugin(name = "ActitoAssetsPlugin")
public class ActitoAssetsPlugin : Plugin() {
    @PluginMethod
    public fun fetch(call: PluginCall) {
        val group = call.getString("group") ?: run {
            call.reject("Missing 'group' parameter.")
            return
        }

        Actito.assets().fetch(group, object : ActitoCallback<List<ActitoAsset>> {
            override fun onSuccess(result: List<ActitoAsset>) {
                try {
                    call.resolve(
                        JSObject().apply {
                            put("result", JSArray().apply {
                                result.forEach { put(it.toJson()) }
                            })
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
}
