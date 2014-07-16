
import Cocoa
import Foundation
import EventKit

var fetching = true


let eventStore = EKEventStore()


func getEvents() -> Array<AnyObject> {
    let startDate = NSDate()
    let endDate = NSDate(timeIntervalSinceNow: 14 * 24 * 60 * 60)
    let predicate = eventStore.predicateForEventsWithStartDate(startDate,
        endDate:endDate,
        calendars:nil)
    
    let theEvents = eventStore.eventsMatchingPredicate(predicate)
    return theEvents
}

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

func convertToJson(value : AnyObject) -> String {
    assert(NSJSONSerialization.isValidJSONObject(value), "Cannot serialise complex values.")
    let options = NSJSONWritingOptions.PrettyPrinted
    let error = AutoreleasingUnsafePointer<NSError?>()
    let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: error);
    
    return NSString(data: data, encoding: NSUTF8StringEncoding)
}

eventStore.requestAccessToEntityType(EKEntityTypeEvent) { (granted, error : NSError!) in
    if granted {
        println(convertToJson(extractEventData(getEvents())))
    } else {
        if let message = error?.localizedDescription? {
            println("ERROR: Access to calendar was refused: \(message)");
        } else {
            println("ERROR: Access to calendar was refused for an unknown reason.")
        }
    }
    fetching = false
}


while (fetching) {
    NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 0.1))
}