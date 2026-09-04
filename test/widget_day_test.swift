// Run with the HydrationDay declaration from DrinklyWidget.swift and Foundation.
var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Istanbul")!
let formatter = ISO8601DateFormatter()
let beforeMidnight = formatter.date(from: "2026-09-04T20:59:59Z")!
let midnight = formatter.date(from: "2026-09-04T21:00:00Z")!
let suite = "drinkly-widget-test-\(UUID().uuidString)"
let defaults = UserDefaults(suiteName: suite)!
defer { defaults.removePersistentDomain(forName: suite) }

defaults.set(1500, forKey: "todayTotal")
assert(HydrationDay.total(from: defaults, at: beforeMidnight, calendar: calendar) == 0)
defaults.set(HydrationDay.key(for: beforeMidnight, calendar: calendar), forKey: "totalDay")
assert(HydrationDay.total(from: defaults, at: beforeMidnight, calendar: calendar) == 1500)
assert(HydrationDay.total(from: defaults, at: midnight, calendar: calendar) == 0)

// First widget tap after midnight must start a new total, not add to yesterday.
let newTotal = HydrationDay.total(from: defaults, at: midnight, calendar: calendar) + 250
defaults.set(newTotal, forKey: "todayTotal")
defaults.set(HydrationDay.key(for: midnight, calendar: calendar), forKey: "totalDay")
assert(HydrationDay.total(from: defaults, at: midnight, calendar: calendar) == 250)
assert(HydrationDay.key(for: midnight, calendar: calendar) == "2026-09-05")
assert(HydrationDay.total(from: nil, at: midnight, calendar: calendar) == 0)

// Calendar days, not fixed 24-hour offsets, also handle DST and year changes.
calendar.timeZone = TimeZone(identifier: "America/New_York")!
for timestamp in ["2026-03-08T05:00:00Z", "2026-11-01T04:00:00Z", "2026-01-01T05:00:00Z"] {
    let start = formatter.date(from: timestamp)!
    let previous = start.addingTimeInterval(-1)
    defaults.set(HydrationDay.key(for: previous, calendar: calendar), forKey: "totalDay")
    assert(HydrationDay.total(from: defaults, at: start, calendar: calendar) == 0)
}
print("Widget day rollover tests passed")
