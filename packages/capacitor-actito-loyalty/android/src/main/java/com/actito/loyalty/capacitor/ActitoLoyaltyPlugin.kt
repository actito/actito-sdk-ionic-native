package com.actito.loyalty.capacitor

import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin
import com.actito.Actito
import com.actito.ActitoCallback
import com.actito.loyalty.ktx.loyalty
import com.actito.loyalty.models.ActitoPass

@CapacitorPlugin(name = "ActitoLoyaltyPlugin")
public class ActitoLoyaltyPlugin : Plugin() {
    @PluginMethod
    public fun fetchPassBySerial(call: PluginCall) {
        val serial = call.getString("serial") ?: run {
            call.reject("Missing 'serial' parameter.")
            return
        }

        Actito.loyalty().fetchPassBySerial(serial, object : ActitoCallback<ActitoPass> {
            override fun onSuccess(result: ActitoPass) {
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
    public fun fetchPassByBarcode(call: PluginCall) {
        val barcode = call.getString("barcode") ?: run {
            call.reject("Missing 'barcode' parameter.")
            return
        }

        Actito.loyalty().fetchPassByBarcode(barcode, object : ActitoCallback<ActitoPass> {
            override fun onSuccess(result: ActitoPass) {
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
    public fun present(call: PluginCall) {
        val json = call.getObject("pass") ?: run {
            call.reject("Missing 'pass' parameter.")
            return
        }

        val pass: ActitoPass = try {
            ActitoPass.fromJson(json)
        } catch (e: Exception) {
            call.reject(e.localizedMessage)
            return
        }

        val activity = activity ?: run {
            call.reject("Cannot present a pass without an activity.")
            return
        }

        Actito.loyalty().present(activity, pass)
        call.resolve()
    }
}
