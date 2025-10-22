import ActitoKit
import Capacitor
import Foundation

@objc(ActitoPlugin)
public class ActitoPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "ActitoPlugin"
    public let jsName = "ActitoPlugin"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "isConfigured", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "isReady", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "launch", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "unlaunch", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getApplication", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "fetchApplication", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "fetchNotification", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "fetchDynamicLink", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "canEvaluateDeferredLink", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "evaluateDeferredLink", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getCurrentDevice", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getPreferredLanguage", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "updatePreferredLanguage", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "register", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "updateUser", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "fetchTags", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "addTag", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "addTags", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "removeTag", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "removeTags", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "clearTags", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "fetchDoNotDisturb", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "updateDoNotDisturb", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "clearDoNotDisturb", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "fetchUserData", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "updateUserData", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "logCustom", returnType: CAPPluginReturnPromise),
    ]

    @MainActor
    public override func load() {
        addApplicationLaunchListener()

        EventBroker.instance.setup { self.notifyListeners($0, data: $1, retainUntilConsumed: $2) }
        Actito.shared.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUrlOpened(notification:)), name: .capacitorOpenURL, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUniversalLink(notification:)), name: .capacitorOpenUniversalLink, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .capacitorOpenURL, object: nil)
        NotificationCenter.default.removeObserver(self, name: .capacitorOpenUniversalLink, object: nil)
    }

    @objc func handleUrlOpened(notification: NSNotification) {
        guard let object = notification.object as? [String: Any?], let url = object["url"] as? URL else {
            logger.warning("Unprocessable url_opened event.")
            return
        }

        DispatchQueue.main.async {
            if Actito.shared.handleTestDeviceUrl(url) {
                return
            }

            if Actito.shared.handleDynamicLinkUrl(url) {
                return
            }

            EventBroker.instance.dispatchEvent("url_opened", data: ["url": url.absoluteString], retainUntilConsumed: true)
        }
    }

    @objc func handleUniversalLink(notification: NSNotification) {
        guard let object = notification.object as? [String: Any?], let url = object["url"] as? URL else {
            logger.warning("Unprocessable universal_link event.")
            return
        }

        DispatchQueue.main.async {
            if Actito.shared.handleTestDeviceUrl(url) {
                return
            }

            _ = Actito.shared.handleDynamicLinkUrl(url)
        }
    }

    // MARK: - Actito

    @objc func isConfigured(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            call.resolve([
                "result": Actito.shared.isConfigured,
            ])
        }
    }

    @objc func isReady(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            call.resolve([
                "result": Actito.shared.isReady,
            ])
        }
    }

    @objc func launch(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Actito.shared.launch { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func unlaunch(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Actito.shared.unlaunch { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func getApplication(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            do {
                var response: PluginCallResultData = [:]
                if let application = Actito.shared.application {
                    response["result"] = try application.toJson()
                }

                call.resolve(response)
            } catch {
                call.reject(error.localizedDescription)
            }
        }
    }

    @objc func fetchApplication(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Actito.shared.fetchApplication { result in
                switch result {
                case let .success(application):
                    do {
                        call.resolve([
                            "result": try application.toJson()
                        ])
                    } catch {
                        call.reject(error.localizedDescription)
                    }
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func fetchNotification(_ call: CAPPluginCall) {
        guard let id = call.getString("id") else {
            call.reject("Missing 'id' parameter.")
            return
        }

        DispatchQueue.main.async {
            Actito.shared.fetchNotification(id) { result in
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
    }

    @objc func fetchDynamicLink(_ call: CAPPluginCall) {
        guard let url = call.getString("url") else {
            call.reject("Missing 'url' parameter.")
            return
        }

        DispatchQueue.main.async {
            Actito.shared.fetchDynamicLink(url) { result in
                switch result {
                case let .success(dynamicLink):
                    do {
                        call.resolve([
                            "result": try dynamicLink.toJson()
                        ])
                    } catch {
                        call.reject(error.localizedDescription)
                    }
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func canEvaluateDeferredLink(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            call.resolve([
                "result": Actito.shared.canEvaluateDeferredLink
            ])
        }
    }

    @objc func evaluateDeferredLink(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Actito.shared.evaluateDeferredLink { result in
                switch result {
                case let .success(evaluated):
                    call.resolve([
                        "result": evaluated
                    ])
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Actito device module

    @objc func getCurrentDevice(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            do {
                var response: PluginCallResultData = [:]
                if let device = Actito.shared.device().currentDevice {
                    response["result"] = try device.toJson()
                }

                call.resolve(response)
            } catch {
                call.reject(error.localizedDescription)
            }
        }
    }

    @objc func getPreferredLanguage(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            var response: PluginCallResultData = [:]
            if let language = Actito.shared.device().preferredLanguage {
                response["result"] = language
            }

            call.resolve(response)
        }
    }

    @objc func updatePreferredLanguage(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let language = call.getString("language")

            Actito.shared.device().updatePreferredLanguage(language) { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func register(_ call: CAPPluginCall) {
        let userId = call.getString("userId")
        let userName = call.getString("userName")

        DispatchQueue.main.async {
            Actito.shared.device().register(userId: userId, userName: userName) { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func updateUser(_ call: CAPPluginCall) {
        let userId = call.getString("userId")
        let userName = call.getString("userName")

        DispatchQueue.main.async {
            Actito.shared.device().updateUser(userId: userId, userName: userName) { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func fetchTags(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Actito.shared.device().fetchTags { result in
                switch result {
                case let .success(tags):
                    call.resolve([
                        "result": tags
                    ])
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func addTag(_ call: CAPPluginCall) {
        guard let tag = call.getString("tag") else {
            call.reject("Missing 'tag' parameter.")
            return
        }

        DispatchQueue.main.async {
            Actito.shared.device().addTag(tag) { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func addTags(_ call: CAPPluginCall) {
        guard let tags = call.getArray("tags", String.self) else {
            call.reject("Missing 'tags' parameter.")
            return
        }

        DispatchQueue.main.async {
            Actito.shared.device().addTags(tags) { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func removeTag(_ call: CAPPluginCall) {
        guard let tag = call.getString("tag") else {
            call.reject("Missing 'tag' parameter.")
            return
        }

        DispatchQueue.main.async {
            Actito.shared.device().removeTag(tag) { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func removeTags(_ call: CAPPluginCall) {
        guard let tags = call.getArray("tags", String.self) else {
            call.reject("Missing 'tags' parameter.")
            return
        }

        DispatchQueue.main.async {
            Actito.shared.device().removeTags(tags) { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func clearTags(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Actito.shared.device().clearTags { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func fetchDoNotDisturb(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Actito.shared.device().fetchDoNotDisturb { result in
                switch result {
                case let .success(dnd):
                    do {
                        var response: PluginCallResultData = [:]
                        if let dnd = dnd {
                            response["result"] = try dnd.toJson()
                        }

                        call.resolve(response)
                    } catch {
                        call.reject(error.localizedDescription)
                    }
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func updateDoNotDisturb(_ call: CAPPluginCall) {
        guard let json = call.getObject("dnd") else {
            call.reject("Missing 'dnd' parameter.")
            return
        }

        let dnd: ActitoDoNotDisturb
        do {
            dnd = try ActitoDoNotDisturb.fromJson(json: json)
        } catch {
            call.reject(error.localizedDescription)
            return
        }

        DispatchQueue.main.async {
            Actito.shared.device().updateDoNotDisturb(dnd) { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func clearDoNotDisturb(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Actito.shared.device().clearDoNotDisturb { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func fetchUserData(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Actito.shared.device().fetchUserData { result in
                switch result {
                case let .success(userData):
                    call.resolve([
                        "result": userData
                    ])
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    @objc func updateUserData(_ call: CAPPluginCall) {
        guard let json = call.getObject("userData") else {
            call.reject("Missing 'userData' parameter.")
            return
        }

        let userData = json.mapValues { $0 as? String }

        DispatchQueue.main.async {
            Actito.shared.device().updateUserData(userData) { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Actito events module

    @objc func logCustom(_ call: CAPPluginCall) {
        guard let event = call.getString("event") else {
            call.reject("Missing 'event' parameter.")
            return
        }

        let data = call.getObject("data")

        DispatchQueue.main.async {
            Actito.shared.events().logCustom(event, data: data) { result in
                switch result {
                case .success:
                    call.resolve()
                case let .failure(error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }
}

extension ActitoPlugin: ActitoDelegate {
    public func actito(_ actito: Actito, onReady application: ActitoApplication) {
        do {
            EventBroker.instance.dispatchEvent("ready", data: try application.toJson())
        } catch {
            logger.error("Failed to emit the ready event.", error: error)
        }
    }

    public func actitoDidUnlaunch(_ actito: Actito) {
        EventBroker.instance.dispatchEvent("unlaunched", data: nil)
    }

    public func actito(_ actito: Actito, didRegisterDevice device: ActitoDevice) {
        do {
            EventBroker.instance.dispatchEvent("device_registered", data: try device.toJson())
        } catch {
            logger.error("Failed to emit the device_registered event.", error: error)
        }
    }
}

extension ActitoPlugin {
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
