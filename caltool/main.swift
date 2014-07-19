/*
Copyright 2014 Adrian Sutton

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import Cocoa
import Foundation
import EventKit

func printError(message : String) {
    let stderr = NSFileHandle.fileHandleWithStandardError()
    stderr.writeData("\(message)\n".dataUsingEncoding(NSUTF8StringEncoding))
}
var fetching = true

var startDate = NSDate()
var endDate = NSDate()
var errorMessages = Array<String>()

let parser = JVArgumentParser()

let error = AutoreleasingUnsafePointer<NSError?>()
let dateDetector = NSDataDetector.dataDetectorWithTypes(NSTextCheckingType.Date.toRaw(), error: error)
func parseDate(value: String, errorMessage: String) -> NSDate {
    let range = NSMakeRange(0, (value as NSString).length)
    let matches = dateDetector.matchesInString(value as NSString, options: nil, range: range)
    if matches.count == 1 {
        return matches[0].date
    } else {
        errorMessages += (errorMessage + ": " + value)
        return NSDate()
    }
}

parser.addOptionWithArgumentWithLongName("from") { value in startDate = parseDate(value, "Invalid from date") }
parser.addOptionWithArgumentWithLongName("to") { value in endDate = parseDate(value, "Invalid to date") }

parser.parse(NSProcessInfo.processInfo().arguments, error: nil)

if (errorMessages.isEmpty) {
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
} else {
    for message in errorMessages {
        printError(message)
    }
    printError("Usage caltool [--from <date>] [--to <date>]")
}