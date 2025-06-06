import ActitoUtilitiesKit
import Foundation

internal var logger: ActitoLogger = {
    var logger = ActitoLogger(
        subsystem: "com.actito.inbox.capacitor",
        category: "ActitoInbox"
    )

    logger.labelIgnoreList.append("ActitoInbox")

    return logger
}()
