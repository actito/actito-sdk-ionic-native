import ActitoKit
import ActitoLoyaltyKit
import Capacitor
import Foundation

@objc(ActitoLoyaltyPlugin)
public class ActitoLoyaltyPlugin: CAPPlugin {
    private var rootViewController: UIViewController? {
        get {
            UIApplication.shared.delegate?.window??.rootViewController
        }
    }

    @objc func fetchPassBySerial(_ call: CAPPluginCall) {
        guard let serial = call.getString("serial") else {
            call.reject("Missing 'serial' parameter.")
            return
        }

        Actito.shared.loyalty().fetchPass(serial: serial) { result in
            switch result {
            case let .success(pass):
                do {
                    call.resolve([
                        "result": try pass.toJson()
                    ])
                } catch {
                    call.reject(error.localizedDescription)
                }
            case let .failure(error):
                call.reject(error.localizedDescription)
            }
        }
    }

    @objc func fetchPassByBarcode(_ call: CAPPluginCall) {
        guard let barcode = call.getString("barcode") else {
            call.reject("Missing 'barcode' parameter.")
            return
        }

        Actito.shared.loyalty().fetchPass(barcode: barcode) { result in
            switch result {
            case let .success(pass):
                do {
                    call.resolve([
                        "result": try pass.toJson()
                    ])
                } catch {
                    call.reject(error.localizedDescription)
                }
            case let .failure(error):
                call.reject(error.localizedDescription)
            }
        }
    }

    @objc func present(_ call: CAPPluginCall) {
        guard let json = call.getObject("pass") else {
            call.reject("Missing 'pass' parameter.")
            return
        }

        let pass: ActitoPass

        do {
            pass = try ActitoPass.fromJson(json: json)
        } catch {
            call.reject(error.localizedDescription)
            return
        }

        DispatchQueue.main.async {
            guard let rootViewController = self.rootViewController else {
                call.reject("Cannot present a pass with a nil root view controller.")
                return
            }

            Actito.shared.loyalty().present(pass: pass, in: rootViewController)
        }
    }
}
