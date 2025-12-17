import ActitoUtilitiesKit
import Foundation

internal let logger: ActitoLogger = {
    var logger = ActitoLogger(
        subsystem: "com.actito.capacitor",
        category: "Actito",
        labelIgnoreList: ["Actito"]
    )

    return logger
}()
