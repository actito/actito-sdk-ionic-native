import ActitoInAppMessagingKit
import ActitoKit
import Capacitor
import Foundation

@objc(ActitoInAppMessagingPlugin)
public class ActitoInAppMessagingPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "ActitoInAppMessagingPlugin" 
    public let jsName = "ActitoInAppMessagingPlugin" 
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "hasMessagesSuppressed", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setMessagesSuppressed", returnType: CAPPluginReturnPromise),
    ] 
    public override func load() {
        addApplicationLaunchListener()

        EventBroker.instance.setup { self.notifyListeners($0, data: $1) }
        Actito.shared.inAppMessaging().delegate = self
    }

    @objc func hasMessagesSuppressed(_ call: CAPPluginCall) {
        call.resolve([
            "result": Actito.shared.inAppMessaging().hasMessagesSuppressed
        ])
    }

    @objc func setMessagesSuppressed(_ call: CAPPluginCall) {
        guard let suppressed = call.getBool("suppressed") else {
            call.reject("Missing 'suppressed' parameter.")
            return
        }

        let evaluateContext = call.getBool("evaluateContext") ?? false

        Actito.shared.inAppMessaging().setMessagesSuppressed(suppressed, evaluateContext: evaluateContext)

        call.resolve()
    }
}

extension ActitoInAppMessagingPlugin: ActitoInAppMessagingDelegate {
    public func actito(_ actito: ActitoInAppMessaging, didPresentMessage message: ActitoInAppMessage) {
        do {
            let data = [
                "message": try message.toJson()
            ]

            EventBroker.instance.dispatchEvent("message_presented", data: data)
        } catch {
            logger.error("Failed to emit the message_presented event.", error: error)
        }
    }

    public func actito(_ actito: ActitoInAppMessaging, didFinishPresentingMessage message: ActitoInAppMessage) {
        do {
            let data = [
                "message": try message.toJson()
            ]

            EventBroker.instance.dispatchEvent("message_finished_presenting", data: data)
        } catch {
            logger.error("Failed to emit the message_finished_presenting event.", error: error)
        }
    }

    public func actito(_ actito: ActitoInAppMessaging, didFailToPresentMessage message: ActitoInAppMessage) {
        do {
            let data = [
                "message": try message.toJson()
            ]

            EventBroker.instance.dispatchEvent("message_failed_to_present", data: data)
        } catch {
            logger.error("Failed to emit the message_failed_to_present event.", error: error)
        }
    }

    public func actito(_ actito: ActitoInAppMessaging, didExecuteAction action: ActitoInAppMessage.Action, for message: ActitoInAppMessage) {
        do {
            let data = [
                "message": try message.toJson(),
                "action": try action.toJson(),
            ]

            EventBroker.instance.dispatchEvent("action_executed", data: data)
        } catch {
            logger.error("Failed to emit the action_executed event.", error: error)
        }
    }

    public func actito(_ actito: ActitoInAppMessaging, didFailToExecuteAction action: ActitoInAppMessage.Action, for message: ActitoInAppMessage, error: Error?) {
        do {
            var data: [String: Any] = [
                "message": try message.toJson(),
                "action": try action.toJson(),
            ]

            if let error = error {
                data["error"] = error.localizedDescription
            }

            EventBroker.instance.dispatchEvent("action_failed_to_execute", data: data)
        } catch {
            logger.error("Failed to emit the action_failed_to_execute event.", error: error)
        }
    }
}

extension ActitoInAppMessagingPlugin {
    private func addApplicationLaunchListener() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didFinishLaunching),
            name: UIApplication.didFinishLaunchingNotification,
            object: nil
        )
    }

    private func removeApplicationLaunchListener() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didFinishLaunchingNotification,
            object: nil
        )
    }

    @objc private func didFinishLaunching() {
        removeApplicationLaunchListener()

        logger.hasDebugLoggingEnabled = Actito.shared.options?.debugLoggingEnabled ?? false
    }
}
