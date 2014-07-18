import Foundation
import EventKit

class EventRetriever {
    let eventStore = EKEventStore()
    
    func getEvents(from startDate: NSDate, to endDate: NSDate) -> Array<EKEvent> {
        let predicate = eventStore.predicateForEventsWithStartDate(startDate,
            endDate:endDate,
            calendars:nil)
        
        var events = Array<EKEvent>()
        for event in eventStore.eventsMatchingPredicate(predicate) {
            if let ekEvent = event as? EKEvent {
                events += ekEvent
            }
        }
        return events
    }

    
    func findEvents(#startDate: NSDate, endDate: NSDate, continuation: (events: Array<EKEvent>?, error: NSError?) -> Void) {
        eventStore.requestAccessToEntityType(EKEntityTypeEvent) { (granted, error : NSError!) in
            if granted {
                continuation(events: self.getEvents(from: startDate, to: endDate), error: nil)
            } else {
                continuation(events: nil, error: error)
            }
            fetching = false
        }

    }
}