
import Cocoa
import Foundation
import EventKit

func printError(message : String) {
    let stderr = NSFileHandle.fileHandleWithStandardError()
    stderr.writeData("\(message)\n".dataUsingEncoding(NSUTF8StringEncoding))
}
var fetching = true

let startDate = NSDate()
let endDate = NSDate(timeIntervalSinceNow: 14 * 24 * 60 * 60)
let retriever = EventRetriever()
let formatter :OutputFormat = JsonOutput()
retriever.findEvents(startDate: startDate, endDate: endDate) { (events, error) in
    if let events = events {
        formatter.printEvents(events, to: NSFileHandle.fileHandleWithStandardOutput())
    } else {
        if let message = error?.localizedDescription? {
            printError("ERROR: Access to calendar was refused: \(message)");
        } else {
            printError("ERROR: Access to calendar was refused.")
        }
    }
    fetching = false
}

while (fetching) {
    NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 0.1))
}