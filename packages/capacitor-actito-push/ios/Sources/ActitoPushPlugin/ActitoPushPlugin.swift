import ActitoKit
import ActitoPushKit
import Capacitor
import Foundation

@objc(ActitoPushPlugin)
public class ActitoPushPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "ActitoPushPlugin"
    public let jsName = "ActitoPushPlugin"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "setAuthorizationOptions", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setCategoryOptions", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setPresentationOptions", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "hasRemoteNotificationsEnabled", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getTransport", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getSubscription", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "allowedUI", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "enableRemoteNotifications", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "disableRemoteNotifications", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "checkPermissionStatus", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "shouldShowPermissionRationale", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "presentPermissionRationale", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "requestPermission", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "openAppSettings", returnType: CAPPluginReturnPromise),
    ]

    private let notificationCenter = UNUserNotificationCenter.current()

    @MainActor
    public override func load() {
        addApplicationLaunchListener()

        EventBroker.instance.setup { self.notifyListeners($0, data: $1, retainUntilConsumed: $2) }
        Actito.shared.push().delegate = self
    }

    @objc func setAuthorizationOptions(_ call: CAPPluginCall) {
        guard let options = call.getArray("options", String.self) else {
            call.reject("Missing 'options' parameter.")
            return
        }

        var authorizationOptions: UNAuthorizationOptions = []

        options.forEach { option in
            if option == "alert" {
                authorizationOptions = [authorizationOptions, .alert]
            }

            if option == "badge" {
                authorizationOptions = [authorizationOptions, .badge]
            }

            if option == "sound" {
                authorizationOptions = [authorizationOptions, .sound]
            }

            if option == "carPlay" {
                authorizationOptions = [authorizationOptions, .carPlay]
            }

            if #available(iOS 12.0, *) {
                if option == "providesAppNotificationSettings" {
                    authorizationOptions = [authorizationOptions, .providesAppNotificationSettings]
                }

                if option == "provisional" {
                    authorizationOptions = [authorizationOptions, .provisional]
                }

                if option == "criticalAlert" {
                    authorizationOptions = [authorizationOptions, .criticalAlert]
                }
            }

            if #available(iOS 13.0, *) {
                if option == "announcement" {
                    authorizationOptions = [authorizationOptions, .announcement]
                }
            }
        }

        DispatchQueue.main.async {
            Actito.shared.push().authorizationOptions = authorizationOptions
            call.resolve()
        }
    }

    @objc func setCategoryOptions(_ call: CAPPluginCall) {
        guard let options = call.getArray("options", String.self) else {
            call.reject("Missing 'options' parameter.")
            return
        }

        var categoryOptions: UNNotificationCategoryOptions = []

        options.forEach { option in
            if option == "customDismissAction" {
                categoryOptions = [categoryOptions, .customDismissAction]
            }

            if option == "allowInCarPlay" {
                categoryOptions = [categoryOptions, .allowInCarPlay]
            }

            if #available(iOS 11.0, *) {
                if option == "hiddenPreviewsShowTitle" {
                    categoryOptions = [categoryOptions, .hiddenPreviewsShowTitle]
                }

                if option == "hiddenPreviewsShowSubtitle" {
                    categoryOptions = [categoryOptions, .hiddenPreviewsShowSubtitle]
                }
            }

            if #available(iOS 13.0, *) {
                if option == "allowAnnouncement" {
                    categoryOptions = [categoryOptions, .allowAnnouncement]
                }
            }
        }

        DispatchQueue.main.async {
            Actito.shared.push().categoryOptions = categoryOptions
            call.resolve()
        }
    }

    @objc func setPresentationOptions(_ call: CAPPluginCall) {
        guard let options = call.getArray("options", String.self) else {
            call.reject("Missing 'options' parameter.")
            return
        }

        var presentationOptions: UNNotificationPresentationOptions = []

        options.forEach { option in
            if #available(iOS 14.0, *) {
                if option == "banner" || option == "alert" {
                    presentationOptions = [presentationOptions, .banner]
                }

                if option == "list" {
                    presentationOptions = [presentationOptions, .list]
                }
            } else {
                if option == "alert" {
                    presentationOptions = [presentationOptions, .alert]
                }
            }

            if option == "badge" {
                presentationOptions = [presentationOptions, .badge]
            }

            if option == "sound" {
                presentationOptions = [presentationOptions, .sound]
            }
        }

        DispatchQueue.main.async {
            Actito.shared.push().presentationOptions = presentationOptions
            call.resolve()
        }
    }

    @objc func hasRemoteNotificationsEnabled(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            call.resolve([
                "result": Actito.shared.push().hasRemoteNotificationsEnabled
            ])
        }
    }

    @objc func getTransport(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            var response: PluginCallResultData = [:]
            if let transport = Actito.shared.push().transport?.rawValue {
                response["result"] = transport
            }

            call.resolve(response)
        }
    }

    @objc func getSubscription(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            do {
                var response: PluginCallResultData = [:]
                if let subscription = Actito.shared.push().subscription {
                    response["result"] = try subscription.toJson()
                }

                call.resolve(response)
            } catch {
                call.reject(error.localizedDescription)
            }
        }
    }

    @objc func allowedUI(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            call.resolve([
                "result": Actito.shared.push().allowedUI
            ])
        }
    }

    @objc func enableRemoteNotifications(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Actito.shared.push().enableRemoteNotifications { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func disableRemoteNotifications(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Actito.shared.push().disableRemoteNotifications { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func checkPermissionStatus(_ call: CAPPluginCall) {
        checkPermissionStatus { status in
            call.resolve(["result": status.rawValue])
        }
    }

    @objc func shouldShowPermissionRationale(_ call: CAPPluginCall) {
        call.resolve(["result": false])
    }

    @objc func presentPermissionRationale(_ call: CAPPluginCall) {
        call.reject("This method is not implemented in iOS.")
    }

    @objc func requestPermission(_ call: CAPPluginCall) {
        checkPermissionStatus { status in
            guard status != .granted && status != .permanentlyDenied else {
                call.resolve(["result": status.rawValue])
                return
            }

            DispatchQueue.main.async {
                let authorizationOptions = Actito.shared.push().authorizationOptions

                self.notificationCenter.requestAuthorization(options: authorizationOptions) { (granted, error) in
                    if error == nil {
                        call.resolve(granted ? ["result": PermissionStatus.granted.rawValue] : ["result": PermissionStatus.denied.rawValue])
                        return
                    }

                    call.reject("Unable to request notifications permission.", error?.localizedDescription)
                }
            }
        }
    }

    @objc func openAppSettings(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else {
                call.reject("Unable to open the application settings.")
                return
            }

            UIApplication.shared.open(url) { success in
                if success {
                    call.resolve()
                } else {
                    call.reject("Unable to open the application settings.")
                }
            }
        }
    }

    private func checkPermissionStatus(_ completion: @escaping (PermissionStatus) -> Void) {
        notificationCenter.getNotificationSettings { status in
            var permissionStatus = PermissionStatus.denied

            if status.authorizationStatus == .authorized {
                permissionStatus = PermissionStatus.granted
            }

            if status.authorizationStatus == .denied {
                permissionStatus = PermissionStatus.permanentlyDenied
            }

            completion(permissionStatus)
        }
    }
}

extension ActitoPushPlugin: ActitoPushDelegate {
    public func actito(_ actitoPush: ActitoPush, didReceiveNotification notification: ActitoNotification, deliveryMechanism: ActitoNotificationDeliveryMechanism) {
        do {
            let data: [String: Any] = [
                "notification": try notification.toJson(),
                "deliveryMechanism": deliveryMechanism.rawValue,
            ]

            EventBroker.instance.dispatchEvent("notification_info_received", data: data)
        } catch {
            logger.error("Failed to emit the notification_info_received event.", error: error)
        }
    }

    public func actito(_ actitoPush: ActitoPush, didReceiveSystemNotification notification: ActitoSystemNotification) {
        do {
            EventBroker.instance.dispatchEvent("system_notification_received", data: try notification.toJson())
        } catch {
            logger.error("Failed to emit the system_notification_received event.", error: error)
        }
    }

    public func actito(_ actitoPush: ActitoPush, didReceiveUnknownNotification userInfo: [AnyHashable: Any]) {
        let data: [String: Any] = Dictionary(uniqueKeysWithValues: userInfo.compactMap {
            guard let key = $0.key as? String else {
                return nil
            }

            return (key, $0.value)
        })

        EventBroker.instance.dispatchEvent("unknown_notification_received", data: data)
    }

    public func actito(_ actitoPush: ActitoPush, didOpenNotification notification: ActitoNotification) {
        do {
            EventBroker.instance.dispatchEvent("notification_opened", data: try notification.toJson(), retainUntilConsumed: true)
        } catch {
            logger.error("Failed to emit the notification_opened event.", error: error)
        }
    }

    public func actito(_ actitoPush: ActitoPush, didOpenUnknownNotification userInfo: [AnyHashable: Any]) {
        let data: [String: Any] = Dictionary(uniqueKeysWithValues: userInfo.compactMap {
            guard let key = $0.key as? String else {
                return nil
            }

            return (key, $0.value)
        })

        EventBroker.instance.dispatchEvent("unknown_notification_opened", data: data, retainUntilConsumed: true)
    }

    public func actito(_ actitoPush: ActitoPush, didOpenAction action: ActitoNotification.Action, for notification: ActitoNotification) {
        do {
            let data = [
                "notification": try notification.toJson(),
                "action": try action.toJson(),
            ]

            EventBroker.instance.dispatchEvent("notification_action_opened", data: data, retainUntilConsumed: true)
        } catch {
            logger.error("Failed to emit the notification_action_opened event.", error: error)
        }
    }

    public func actito(_ actitoPush: ActitoPush, didOpenUnknownAction action: String, for notification: [AnyHashable: Any], responseText: String?) {
        let notificationMap: [String: Any] = Dictionary(uniqueKeysWithValues: notification.compactMap {
            guard let key = $0.key as? String else {
                return nil
            }

            return (key, $0.value)
        })

        var data: [String: Any] = [
            "notification": notificationMap,
            "action": action,
        ]

        if let responseText = responseText {
            data["responseText"] = responseText
        }

        EventBroker.instance.dispatchEvent("unknown_notification_action_opened", data: data, retainUntilConsumed: true)
    }

    public func actito(_ actitoPush: ActitoPush, didChangeNotificationSettings granted: Bool) {
        EventBroker.instance.dispatchEvent("notification_settings_changed", data: ["granted": granted])
    }

    public func actito(_ actitoPush: ActitoPush, didChangeSubscription subscription: ActitoPushSubscription?) {
        do {
            EventBroker.instance.dispatchEvent("subscription_changed", data: try subscription?.toJson())
        } catch {
            logger.error("Failed to emit the subscription_changed event.", error: error)
        }
    }

    public func actito(_ actitoPush: ActitoPush, shouldOpenSettings notification: ActitoNotification?) {
        do {
            EventBroker.instance.dispatchEvent("should_open_notification_settings", data: try notification?.toJson())
        } catch {
            logger.error("Failed to emit the should_open_notification_settings event.", error: error)
        }
    }

    public func actito(_ actitoPush: ActitoPush, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        EventBroker.instance.dispatchEvent("failed_to_register_for_remote_notifications", data: ["error": error.localizedDescription])
    }
}

extension ActitoPushPlugin {
    internal enum PermissionStatus: String, CaseIterable {
        case denied = "denied"
        case granted = "granted"
        case permanentlyDenied = "permanently_denied"
    }
}

extension ActitoPushPlugin {
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
