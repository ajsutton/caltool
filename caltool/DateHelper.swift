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

class DateHelper {
    let calendar = NSCalendar.currentCalendar()
    
    let isoDateTimeFormatter = NSDateFormatter()
    let userDateFormatter = NSDateFormatter()
    let userDateTimeFormatter = NSDateFormatter()
    
    init() {
        isoDateTimeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        userDateFormatter.dateStyle = .MediumStyle
        userDateFormatter.timeStyle = .NoStyle
        userDateTimeFormatter.dateStyle = .MediumStyle
        userDateTimeFormatter.timeStyle = .MediumStyle
    }
    
    
    var startOfCurrentDay: NSDate {
        get {
            let now = NSDate()
            let components = calendar.components(.YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit, fromDate: now);
            return calendar.dateFromComponents(components)
        }
    }
    
    var endOfCurrentDay: NSDate {
        get {
            return calendar.dateByAddingUnit(NSCalendarUnit.DayCalendarUnit, value: 1, toDate: self.startOfCurrentDay,
                options: nil)
        }
    }
}