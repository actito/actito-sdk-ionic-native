import ActitoUtilitiesKit
import Foundation

internal let logger: ActitoLogger = {
    var logger = ActitoLogger(
        subsystem: "com.actito.push.ui.capacitor",
        category: "ActitoPushUI",
        labelIgnoreList: ["ActitoPushUI"]
    )

    return logger
}()
