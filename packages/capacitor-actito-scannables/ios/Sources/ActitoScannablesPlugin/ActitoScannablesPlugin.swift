import ActitoKit
import ActitoScannablesKit
import Capacitor
import Foundation

@objc(ActitoScannablesPlugin)
public class ActitoScannablesPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "ActitoScannablesPlugin" 
    public let jsName = "ActitoScannablesPlugin" 
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "canStartNfcScannableSession", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "startScannableSession", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "startNfcScannableSession", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "startQrCodeScannableSession", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "fetch", returnType: CAPPluginReturnPromise),
    ] 
    private var rootViewController: UIViewController? {
        get {
            UIApplication.shared.delegate?.window??.rootViewController
        }
    }

    public override func load() {
        addApplicationLaunchListener()

        EventBroker.instance.setup { self.notifyListeners($0, data: $1) }
        Actito.shared.scannables().delegate = self
    }

    @objc func canStartNfcScannableSession(_ call: CAPPluginCall) {
        call.resolve([
            "result": Actito.shared.scannables().canStartNfcScannableSession
        ])
    }

    @objc func startScannableSession(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            guard let rootViewController = self.rootViewController else {
                call.reject("Cannot start a scannable session with a nil root view controller.")
                return
            }

            Actito.shared.scannables().startScannableSession(controller: rootViewController)
            call.resolve()
        }
    }

    @objc func startNfcScannableSession(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Actito.shared.scannables().startNfcScannableSession()
            call.resolve()
        }
    }

    @objc func startQrCodeScannableSession(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            guard let rootViewController = self.rootViewController else {
                call.reject("Cannot start a scannable session with a nil root view controller.")
                return
            }

            Actito.shared.scannables().startQrCodeScannableSession(controller: rootViewController, modal: true)
            call.resolve()
        }
    }

    @objc func fetch(_ call: CAPPluginCall) {
        guard let tag = call.getString("tag") else {
            call.reject("Missing 'tag' parameter.")
            return
        }

        Actito.shared.scannables().fetch(tag: tag) { result in
            switch result {
            case let .success(scannable):
                do {
                    call.resolve([
                        "result": try scannable.toJson()
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

extension ActitoScannablesPlugin: ActitoScannablesDelegate {
    public func actito(_ actitoScannables: ActitoScannables, didDetectScannable scannable: ActitoScannable) {
        do {
            EventBroker.instance.dispatchEvent("scannable_detected", data: try scannable.toJson())
        } catch {
            logger.error("Failed to emit the scannable_detected event.", error: error)
        }
    }

    public func actito(_ actitoScannables: ActitoScannables, didInvalidateScannerSession error: Error) {
        EventBroker.instance.dispatchEvent("scannable_session_failed", data: [
            "error": error.localizedDescription
        ])
    }
}

extension ActitoScannablesPlugin {
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
