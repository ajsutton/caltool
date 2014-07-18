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