import Foundation
import ActitoUtilitiesKit

internal var logger: ActitoLogger = {
    var logger = ActitoLogger(
        subsystem: "com.actito.iam.capacitor",
        category: "ActitoInAppMessaging"
    )

    logger.labelIgnoreList.append("ActitoInAppMessaging")

    return logger
}()
