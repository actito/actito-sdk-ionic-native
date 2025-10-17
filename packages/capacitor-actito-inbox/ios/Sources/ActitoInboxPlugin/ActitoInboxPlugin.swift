import ActitoInboxKit
import ActitoKit
import Capacitor
import Foundation

@objc(ActitoInboxPlugin)
public class ActitoInboxPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "ActitoInboxPlugin"
    public let jsName = "ActitoInboxPlugin"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "getItems", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getBadge", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "refresh", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "open", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "markAsRead", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "markAllAsRead", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "remove", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "clear", returnType: CAPPluginReturnPromise),
    ]

    public override func load() {
        addApplicationLaunchListener()

        EventBroker.instance.setup { self.notifyListeners($0, data: $1) }
        Actito.shared.inbox().delegate = self
    }

    @objc func getItems(_ call: CAPPluginCall) {
        do {
            call.resolve([
                "result": try Actito.shared.inbox().items.map { try $0.toJson() }
            ])
        } catch {
            call.reject(error.localizedDescription)
        }
    }

    @objc func getBadge(_ call: CAPPluginCall) {
        call.resolve([
            "result": Actito.shared.inbox().badge
        ])
    }

    @objc func refresh(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Actito.shared.inbox().refresh { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func open(_ call: CAPPluginCall) {
        guard let json = call.getObject("item") else {
            call.reject("Missing 'item' parameter.")
            return
        }

        let item: ActitoInboxItem

        do {
            item = try ActitoInboxItem.fromJson(json: json)
        } catch {
            call.reject(error.localizedDescription)
            return
        }

        Actito.shared.inbox().open(item) { result in
            switch result {
            case let .success(notification):
                do {
                    call.resolve([
                        "result": try notification.toJson()
                    ])
                } catch {
                    call.reject(error.localizedDescription)
                }
            case let .failure(error):
                call.reject(error.localizedDescription)
            }
        }
    }

    @objc func markAsRead(_ call: CAPPluginCall) {
        guard let json = call.getObject("item") else {
            call.reject("Missing 'item' parameter.")
            return
        }

        let item: ActitoInboxItem

        do {
            item = try ActitoInboxItem.fromJson(json: json)
        } catch {
            call.reject(error.localizedDescription)
            return
        }

        Actito.shared.inbox().markAsRead(item) { result in
            switch result {
            case .success:
                call.resolve()
            case let .failure(error):
                call.reject(error.localizedDescription)
            }
        }
    }

    @objc func markAllAsRead(_ call: CAPPluginCall) {
        Actito.shared.inbox().markAllAsRead { result in
            switch result {
            case .success:
                call.resolve()
            case let .failure(error):
                call.reject(error.localizedDescription)
            }
        }
    }

    @objc func remove(_ call: CAPPluginCall) {
        guard let json = call.getObject("item") else {
            call.reject("Missing 'item' parameter.")
            return
        }

        let item: ActitoInboxItem

        do {
            item = try ActitoInboxItem.fromJson(json: json)
        } catch {
            call.reject(error.localizedDescription)
            return
        }

        Actito.shared.inbox().remove(item) { result in
            switch result {
            case .success:
                call.resolve()
            case let .failure(error):
                call.reject(error.localizedDescription)
            }
        }
    }

    @objc func clear(_ call: CAPPluginCall) {
        Actito.shared.inbox().clear { result in
            switch result {
            case .success:
                call.resolve()
            case let .failure(error):
                call.reject(error.localizedDescription)
            }
        }
    }
}

extension ActitoInboxPlugin: ActitoInboxDelegate {
    public func actito(_ actitoInbox: ActitoInbox, didUpdateInbox items: [ActitoInboxItem]) {
        do {
            EventBroker.instance.dispatchEvent("inbox_updated", data: [
                "items": try items.map { try $0.toJson() }
            ])
        } catch {
            logger.error("Failed to emit the inbox_updated event.", error: error)
        }
    }

    public func actito(_ actitoInbox: ActitoInbox, didUpdateBadge badge: Int) {
        EventBroker.instance.dispatchEvent("badge_updated", data: [
            "badge": badge
        ])
    }
}

extension ActitoInboxPlugin {
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
