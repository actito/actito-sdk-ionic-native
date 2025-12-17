import ActitoUtilitiesKit
import Foundation

internal let logger: ActitoLogger = {
    var logger = ActitoLogger(
        subsystem: "com.actito.inbox.capacitor",
        category: "ActitoInbox",
        labelIgnoreList: ["ActitoInbox"]
    )

    return logger
}()
