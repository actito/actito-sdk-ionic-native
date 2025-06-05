import Foundation
import ActitoUtilitiesKit

internal var logger: ActitoLogger = {
    var logger = ActitoLogger(
        subsystem: "com.actito.capacitor",
        category: "Actito"
    )

    logger.labelIgnoreList.append("Actito")

    return logger
}()
