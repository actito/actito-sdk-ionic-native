import ActitoUtilitiesKit
import Foundation

internal var logger: ActitoLogger = {
    var logger = ActitoLogger(
        subsystem: "com.actito.push.ui.capacitor",
        category: "ActitoPushUI"
    )

    logger.labelIgnoreList.append("ActitoPushUI")

    return logger
}()
