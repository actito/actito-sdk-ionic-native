import ActitoUtilitiesKit
import Foundation

internal let logger: ActitoLogger = {
    var logger = ActitoLogger(
        subsystem: "com.actito.geo.capacitor",
        category: "ActitoGeo",
        labelIgnoreList: ["ActitoGeo"]
    )

    return logger
}()
