import ActitoKit
import ActitoPushUIKit
import Capacitor
import Foundation

@objc(ActitoPushUIPlugin)
public class ActitoPushUIPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "ActitoPushUIPlugin"
    public let jsName = "ActitoPushUIPlugin"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "presentNotification", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "presentAction", returnType: CAPPluginReturnPromise),
    ]

    private var rootViewController: UIViewController? {
        get {
            UIApplication.shared.delegate?.window??.rootViewController
        }
    }

    @MainActor
    public override func load() {
        addApplicationLaunchListener()

        EventBroker.instance.setup { self.notifyListeners($0, data: $1) }
        Actito.shared.pushUI().delegate = self
    }

    @objc func presentNotification(_ call: CAPPluginCall) {
        guard let json = call.getObject("notification") else {
            call.reject("Missing 'notification' parameter.")
            return
        }

        let notification: ActitoNotification

        do {
            notification = try ActitoNotification.fromJson(json: json)
        } catch {
            call.reject(error.localizedDescription)
            return
        }

        DispatchQueue.main.async {
            guard let rootViewController = self.rootViewController else {
                call.reject("Cannot present a notification with a nil root view controller.", nil)
                return
            }

            if notification.requiresViewController {
                let navigationController = self.createNavigationController()
                rootViewController.present(navigationController, animated: true) {
                    Actito.shared.pushUI().presentNotification(notification, in: navigationController)
                    call.resolve()
                }
            } else {
                Actito.shared.pushUI().presentNotification(notification, in: rootViewController)
                call.resolve()
            }
        }
    }

    @objc func presentAction(_ call: CAPPluginCall) {
        guard let notificationJson = call.getObject("notification") else {
            call.reject("Missing 'notification' parameter.")
            return
        }

        guard let actionJson = call.getObject("action") else {
            call.reject("Missing 'action' parameter.")
            return
        }

        let notification: ActitoNotification
        let action: ActitoNotification.Action

        do {
            notification = try ActitoNotification.fromJson(json: notificationJson)
            action = try ActitoNotification.Action.fromJson(json: actionJson)
        } catch {
            call.reject(error.localizedDescription)
            return
        }

        DispatchQueue.main.async {
            guard let rootViewController = self.rootViewController else {
                call.reject("Cannot present a notification with a nil root view controller.", nil)
                return
            }

            Actito.shared.pushUI().presentAction(action, for: notification, in: rootViewController)
            call.resolve()
        }
    }

    @MainActor
    private func createNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        let theme = Actito.shared.options?.theme(for: navigationController)

        if let colorStr = theme?.backgroundColor {
            navigationController.view.backgroundColor = UIColor(hexString: colorStr)
        } else {
            if #available(iOS 13.0, *) {
                navigationController.view.backgroundColor = .systemBackground
            } else {
                navigationController.view.backgroundColor = .white
            }
        }

        return navigationController
    }

    @objc private func onCloseClicked() {
        guard let rootViewController = rootViewController else {
            return
        }

        rootViewController.dismiss(animated: true, completion: nil)
    }
}

extension ActitoPushUIPlugin: ActitoPushUIDelegate {
    public func actito(_ actitoPushUI: ActitoPushUI, willPresentNotification notification: ActitoNotification) {
        do {
            EventBroker.instance.dispatchEvent("notification_will_present", data: try notification.toJson())
        } catch {
            logger.error("Failed to emit the notification_will_present event.", error: error)
        }
    }

    public func actito(_ actitoPushUI: ActitoPushUI, didPresentNotification notification: ActitoNotification) {
        do {
            EventBroker.instance.dispatchEvent("notification_presented", data: try notification.toJson())
        } catch {
            logger.error("Failed to emit the notification_presented event.", error: error)
        }
    }

    public func actito(_ actitoPushUI: ActitoPushUI, didFinishPresentingNotification notification: ActitoNotification) {
        do {
            EventBroker.instance.dispatchEvent("notification_finished_presenting", data: try notification.toJson())
        } catch {
            logger.error("Failed to emit the notification_finished_presenting event.", error: error)
        }
    }

    public func actito(_ actitoPushUI: ActitoPushUI, didFailToPresentNotification notification: ActitoNotification) {
        do {
            EventBroker.instance.dispatchEvent("notification_failed_to_present", data: try notification.toJson())
        } catch {
            logger.error("Failed to emit the notification_failed_to_present event.", error: error)
        }
    }

    public func actito(_ actitoPushUI: ActitoPushUI, didClickURL url: URL, in notification: ActitoNotification) {
        do {
            EventBroker.instance.dispatchEvent("notification_url_clicked", data: [
                "notification": try notification.toJson(),
                "url": url.absoluteString,
            ])
        } catch {
            logger.error("Failed to emit the notification_url_clicked event.", error: error)
        }
    }

    public func actito(_ actitoPushUI: ActitoPushUI, willExecuteAction action: ActitoNotification.Action, for notification: ActitoNotification) {
        do {
            EventBroker.instance.dispatchEvent("action_will_execute", data: [
                "notification": try notification.toJson(),
                "action": try action.toJson(),
            ])
        } catch {
            logger.error("Failed to emit the action_will_execute event.", error: error)
        }
    }

    public func actito(_ actitoPushUI: ActitoPushUI, didExecuteAction action: ActitoNotification.Action, for notification: ActitoNotification) {
        do {
            EventBroker.instance.dispatchEvent("action_executed", data: [
                "notification": try notification.toJson(),
                "action": try action.toJson(),
            ])
        } catch {
            logger.error("Failed to emit the action_executed event.", error: error)
        }
    }

    public func actito(_ actitoPushUI: ActitoPushUI, didNotExecuteAction action: ActitoNotification.Action, for notification: ActitoNotification) {
        do {
            EventBroker.instance.dispatchEvent("action_not_executed", data: [
                "notification": try notification.toJson(),
                "action": try action.toJson(),
            ])
        } catch {
            logger.error("Failed to emit the action_not_executed event.", error: error)
        }
    }

    public func actito(_ actitoPushUI: ActitoPushUI, didFailToExecuteAction action: ActitoNotification.Action, for notification: ActitoNotification, error: Error?) {
        do {
            var data: [String: Any] = [
                "notification": try notification.toJson(),
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

    public func actito(_ actitoPushUI: ActitoPushUI, didReceiveCustomAction url: URL, in action: ActitoNotification.Action, for notification: ActitoNotification) {
        do {
            EventBroker.instance.dispatchEvent("custom_action_received", data: [
                "notification": try notification.toJson(),
                "action": try action.toJson(),
                "url": url.absoluteString,
            ])
        } catch {
            logger.error("Failed to emit the custom_action_received event.", error: error)
        }
    }
}

extension ActitoPushUIPlugin {
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

    @MainActor
    @objc private func didFinishLaunching() {
        removeApplicationLaunchListener()

        logger.hasDebugLoggingEnabled = Actito.shared.options?.debugLoggingEnabled ?? false
    }
}
