import EventKit

protocol OutputFormat {
    func printEvents(events: Array<EKEvent>, to: NSFileHandle)
}