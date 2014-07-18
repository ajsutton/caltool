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

import Foundation
import EventKit

class JsonOutput: OutputFormat {
    
    func extractEventData(theEvents : Array<AnyObject>) -> Array<Dictionary<String, String>> {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        var eventsData = Array<Dictionary<String, String>>()
        for eventObj in theEvents {
            if let event = eventObj as? EKEvent {
                var entry = Dictionary<String, String>()
                if let title = event.title {
                    entry["title"] = title
                }
                if let start = event.startDate {
                    entry["start"] = dateFormatter.stringFromDate(start)
                }
                if let end = event.endDate {
                    entry["end"] = dateFormatter.stringFromDate(end)
                }
                entry["allDay"] = event.allDay ? "true" : "false"
                eventsData += entry
            }
        }
        return eventsData
    }
    
    func outputJsonFor(value : AnyObject, to file: NSFileHandle) {
        assert(NSJSONSerialization.isValidJSONObject(value), "Cannot serialise complex values to JSON.")
        let options = NSJSONWritingOptions.PrettyPrinted
        let error = AutoreleasingUnsafePointer<NSError?>()
        
        if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: error) {
            file.writeData(data)
        } else {
            printError("Failed to serialise calendar to JSON \(error.memory?.localizedDescription?).")
        }
    }

    func printEvents(events: Array<EKEvent>, to file: NSFileHandle) {
        outputJsonFor(extractEventData(events), to: file)
    }
}