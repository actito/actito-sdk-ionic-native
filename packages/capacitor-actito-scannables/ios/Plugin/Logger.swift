import Foundation
import ActitoUtilitiesKit

internal var logger: ActitoLogger = {
    var logger = ActitoLogger(
        subsystem: "com.actito.scannables.capacitor",
        category: "ActitoScannables"
    )

    logger.labelIgnoreList.append("ActitoScannables")

    return logger
}()
