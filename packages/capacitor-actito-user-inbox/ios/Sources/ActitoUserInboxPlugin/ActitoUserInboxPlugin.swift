import ActitoKit
import ActitoUserInboxKit
import Capacitor
import Foundation

@objc(ActitoUserInboxPlugin)
public class ActitoUserInboxPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "ActitoUserInboxPlugin"
    public let jsName = "ActitoUserInboxPlugin"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "parseResponseFromJson", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "parseResponseFromString", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "open", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "markAsRead", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "remove", returnType: CAPPluginReturnPromise),
    ]

    @objc func parseResponseFromJson(_ call: CAPPluginCall) {
        guard let json = call.getObject("json") else {
            call.reject("Missing 'json' parameter.")
            return
        }

        do {
            let response = try Actito.shared.userInbox().parseResponse(json: json)

            call.resolve([
                "result": try response.toJson()
            ])
        } catch {
            call.reject(error.localizedDescription)
        }
    }

    @objc func parseResponseFromString(_ call: CAPPluginCall) {
        guard let json = call.getString("json") else {
            call.reject("Missing 'json' parameter.")
            return
        }

        do {
            let response = try Actito.shared.userInbox().parseResponse(string: json)

            call.resolve([
                "result": try response.toJson()
            ])
        } catch {
            call.reject(error.localizedDescription)
        }
    }

    @objc func open(_ call: CAPPluginCall) {
        guard let json = call.getObject("item") else {
            call.reject("Missing 'item' parameter.")
            return
        }

        let item: ActitoUserInboxItem

        do {
            item = try ActitoUserInboxItem.fromJson(json: json)
        } catch {
            call.reject(error.localizedDescription)
            return
        }

        Actito.shared.userInbox().open(item) { result in
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

        let item: ActitoUserInboxItem

        do {
            item = try ActitoUserInboxItem.fromJson(json: json)
        } catch {
            call.reject(error.localizedDescription)
            return
        }

        Actito.shared.userInbox().markAsRead(item) { result in
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

        let item: ActitoUserInboxItem

        do {
            item = try ActitoUserInboxItem.fromJson(json: json)
        } catch {
            call.reject(error.localizedDescription)
            return
        }

        Actito.shared.userInbox().remove(item) { result in
            switch result {
            case .success:
                call.resolve()
            case let .failure(error):
                call.reject(error.localizedDescription)
            }
        }
    }
}
