import Foundation
import ActitoUtilitiesKit

internal var logger: ActitoLogger = {
    var logger = ActitoLogger(
        subsystem: "com.actito.geo.capacitor",
        category: "ActitoGeo"
    )

    logger.labelIgnoreList.append("ActitoGeo")

    return logger
}()
