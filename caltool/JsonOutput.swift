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