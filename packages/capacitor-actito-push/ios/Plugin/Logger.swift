import Foundation
import ActitoUtilitiesKit

internal var logger: ActitoLogger = {
    var logger = ActitoLogger(
        subsystem: "com.actito.push.capacitor",
        category: "ActitoPush"
    )

    logger.labelIgnoreList.append("ActitoPush")

    return logger
}()
