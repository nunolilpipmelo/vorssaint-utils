// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

/// The decisions behind the world clock, kept free of views and of the shared
/// store so they can be tested with a fixed date, zone and locale.
///
/// A zone is saved by its IANA identifier ("Europe/Lisbon"), or by `localID`
/// for whatever zone the Mac is in, so the local row follows the Mac across
/// travel instead of freezing the zone it had when it was added.
enum WorldClockSupport {
    static let localID = "local"
    static let maxMenuBarZones = 2
    /// The timeline moves in quarter hours, a day either way.
    static let scrubStepMinutes = 15
    static let scrubRangeMinutes = 24 * 60

    // MARK: - Saved lists

    /// Saved identifiers in order, without duplicates or zones this Mac no
    /// longer knows.
    static func parse(_ raw: String) -> [String] {
        var seen = Set<String>()
        var result: [String] = []
        for part in raw.split(separator: ",") {
            let id = part.trimmingCharacters(in: .whitespaces)
            guard isValid(id), seen.insert(id).inserted else { continue }
            result.append(id)
        }
        return result
    }

    static func join(_ ids: [String]) -> String {
        ids.joined(separator: ",")
    }

    static func isValid(_ id: String) -> Bool {
        id == localID || TimeZone(identifier: id) != nil
    }

    /// The zones pinned to the menu bar: only listed ones, in list order,
    /// at most `maxMenuBarZones`.
    static func menuBarZones(pinned: [String], listed: [String]) -> [String] {
        let pinnedSet = Set(pinned)
        return Array(listed.filter { pinnedSet.contains($0) }.prefix(maxMenuBarZones))
    }

    /// Pinning past the limit drops the oldest pin, so the newest choice
    /// always lands in the menu bar.
    static func togglingPin(_ id: String, in pinned: [String]) -> [String] {
        if pinned.contains(id) { return pinned.filter { $0 != id } }
        return Array((pinned + [id]).suffix(maxMenuBarZones))
    }

    // MARK: - Zones and names

    static func timeZone(for id: String, local: TimeZone = .current) -> TimeZone {
        id == localID ? local : (TimeZone(identifier: id) ?? local)
    }

    /// The city part of an identifier: "America/Sao_Paulo" reads "Sao Paulo",
    /// "America/Argentina/Buenos_Aires" reads "Buenos Aires".
    static func cityName(forIdentifier identifier: String) -> String {
        let city = identifier.split(separator: "/").last.map(String.init) ?? identifier
        return city.replacingOccurrences(of: "_", with: " ")
    }

    static func cityName(for id: String, local: TimeZone = .current) -> String {
        cityName(forIdentifier: timeZone(for: id, local: local).identifier)
    }

    /// A short menu bar label: the first three letters ("LIS"), or the
    /// initials of a multi-word city ("NY" for New York).
    static func shortLabel(for id: String, local: TimeZone = .current) -> String {
        let city = cityName(for: id, local: local)
        let words = city.split(separator: " ").filter { !$0.isEmpty }
        let label: String
        if words.count > 1 {
            label = words.prefix(3).compactMap(\.first).map(String.init).joined()
        } else {
            label = String(city.prefix(3))
        }
        return label.uppercased()
    }

    // MARK: - Your own labels

    /// Long enough for "🇧🇷 Mãe" or "Client", short enough for the menu bar.
    /// Counted in characters as people see them, so an emoji is one.
    static let maxLabelLength = 8

    static func cappedLabel(_ text: String) -> String {
        String(text.prefix(maxLabelLength))
    }

    /// The label the user gave a zone, trimmed; nil when there is none.
    static func customLabel(for id: String, labels: [String: String]) -> String? {
        guard let text = labels[id]?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            return nil
        }
        return cappedLabel(text)
    }

    /// The menu bar label: the user's own (text, an emoji or both), else the
    /// city's short label.
    static func menuBarLabel(for id: String, labels: [String: String], local: TimeZone = .current) -> String {
        customLabel(for: id, labels: labels) ?? shortLabel(for: id, local: local)
    }

    /// Keeps only the labels of listed zones that have something in them.
    static func cleaned(_ labels: [String: String], keeping ids: [String]) -> [String: String] {
        let listed = Set(ids)
        return labels.filter { listed.contains($0.key) && customLabel(for: $0.key, labels: labels) != nil }
    }

    // MARK: - Formatting

    /// Whether the locale writes times on a 24-hour clock. macOS folds the
    /// user's own "24-hour time" choice into the current locale.
    static func uses24HourClock(locale: Locale = .current) -> Bool {
        let format = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale) ?? "H"
        return !format.contains("a")
    }

    /// "21:00" or "9:00 PM". The compact form drops the space before the
    /// day period so it fits the menu bar.
    static func timeString(_ date: Date,
                           in zone: TimeZone,
                           locale: Locale = .current,
                           compact: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = zone
        if uses24HourClock(locale: locale) {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.setLocalizedDateFormatFromTemplate("hmm")
        }
        let text = formatter.string(from: date)
        guard compact else { return text }
        return text.replacingOccurrences(of: "\u{202F}", with: "").replacingOccurrences(of: " ", with: "")
    }

    /// Minutes the zone is ahead (positive) or behind (negative) the local
    /// zone at that moment, daylight saving included.
    static func offsetMinutes(of zone: TimeZone, from local: TimeZone, at date: Date) -> Int {
        (zone.secondsFromGMT(for: date) - local.secondsFromGMT(for: date)) / 60
    }

    /// "+3h", "−5h30", "+5h45"; empty when both zones agree.
    static func offsetText(minutes: Int) -> String {
        guard minutes != 0 else { return "" }
        let sign = minutes > 0 ? "+" : "\u{2212}"
        let hours = abs(minutes) / 60
        let rest = abs(minutes) % 60
        return rest == 0 ? "\(sign)\(hours)h" : "\(sign)\(hours)h\(String(format: "%02d", rest))"
    }

    /// The zone's calendar day at `date` compared with the local today:
    /// -1 yesterday, 0 today, 1 tomorrow. Measured from the local today, so
    /// a timeline dragged a day ahead reads "Tomorrow" on the local row too.
    static func dayShift(at date: Date, in zone: TimeZone, comparedWith now: Date, localZone: TimeZone) -> Int {
        var zoneCalendar = Calendar(identifier: .gregorian)
        zoneCalendar.timeZone = zone
        var localCalendar = Calendar(identifier: .gregorian)
        localCalendar.timeZone = localZone
        let there = zoneCalendar.dateComponents([.year, .month, .day], from: date)
        let today = localCalendar.dateComponents([.year, .month, .day], from: now)
        let plain = Calendar(identifier: .gregorian)
        guard let thereDay = plain.date(from: there), let todayDay = plain.date(from: today) else { return 0 }
        return plain.dateComponents([.day], from: todayDay, to: thereDay).day ?? 0
    }

    static func dayText(shift: Int, strings: WorldClockFeatureStrings) -> String {
        switch shift {
        case 0: return strings.today
        case 1: return strings.tomorrow
        case -1: return strings.yesterday
        default: return shift > 0 ? "+\(shift)d" : "\u{2212}\(abs(shift))d"
        }
    }

    /// Minutes since that zone's midnight, for the 24-hour bar.
    static func minuteOfDay(_ date: Date, in zone: TimeZone) -> Int {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = zone
        let parts = calendar.dateComponents([.hour, .minute], from: date)
        return (parts.hour ?? 0) * 60 + (parts.minute ?? 0)
    }

    static let defaultWorkStartMinute = 9 * 60
    static let defaultWorkEndMinute = 18 * 60
    static let minutesPerDay = 24 * 60

    /// The working day as minute ranges on a 0–1440 axis. A night shift that
    /// crosses midnight (22:00 to 06:00) becomes two ranges; equal times
    /// mean none.
    static func workingRanges(startMinute: Int, endMinute: Int) -> [Range<Int>] {
        let start = max(0, min(minutesPerDay - 1, startMinute))
        let end = max(0, min(minutesPerDay, endMinute))
        if start < end { return [start..<end] }
        if start == end { return [] }
        return [start..<minutesPerDay, 0..<end].filter { !$0.isEmpty }
    }

    static func isWorkingTime(minuteOfDay: Int,
                              startMinute: Int = defaultWorkStartMinute,
                              endMinute: Int = defaultWorkEndMinute) -> Bool {
        workingRanges(startMinute: startMinute, endMinute: endMinute)
            .contains { $0.contains(minuteOfDay) }
    }

    /// A typed time as minutes since midnight: "9", "09", "930", "0930",
    /// "9:30", "9.30" and "9h30" all read 9:30. "24:00" is only accepted as
    /// an end, meaning midnight at the close of the day. Anything else is nil.
    static func parseTime(_ text: String, allowsEndOfDay: Bool = false) -> Int? {
        let cleaned = text.trimmingCharacters(in: .whitespaces).lowercased()
        let separators = CharacterSet(charactersIn: ":.h")
        let parts = cleaned.components(separatedBy: separators).filter { !$0.isEmpty }
        let hours: Int
        let minutes: Int
        if parts.count == 2, let h = Int(parts[0]), let m = Int(parts[1]), parts[1].count == 2 {
            hours = h
            minutes = m
        } else if parts.count == 1, parts[0].allSatisfy(\.isNumber), (1...4).contains(parts[0].count) {
            let digits = parts[0]
            if digits.count <= 2 {
                hours = Int(digits) ?? -1
                minutes = 0
            } else {
                hours = Int(digits.dropLast(2)) ?? -1
                minutes = Int(digits.suffix(2)) ?? -1
            }
        } else {
            return nil
        }
        guard (0...59).contains(minutes) else { return nil }
        if hours == 24, minutes == 0, allowsEndOfDay { return minutesPerDay }
        guard (0...23).contains(hours) else { return nil }
        return hours * 60 + minutes
    }

    /// "09:30", and "24:00" for the end of the day.
    static func formatTime(_ minutes: Int) -> String {
        let clamped = max(0, min(minutesPerDay, minutes))
        return String(format: "%02d:%02d", clamped / 60, clamped % 60)
    }

    // MARK: - Menu bar

    /// One clock line: an optional label drawn at the left and the time at
    /// the right, so the times line up whatever the labels' lengths.
    struct MenuBarLine: Hashable {
        var label: String?
        var time: String

        /// The single-line form, used when only one zone is pinned.
        var joined: String { label.map { "\($0) \(time)" } ?? time }
    }

    static func menuBarLines(now: Date,
                             zones: [String],
                             showLabels: Bool,
                             labels: [String: String] = [:],
                             locale: Locale = .current,
                             local: TimeZone = .current) -> [MenuBarLine] {
        zones.map { id in
            let time = timeString(now, in: timeZone(for: id, local: local), locale: locale, compact: true)
            return MenuBarLine(label: showLabels ? menuBarLabel(for: id, labels: labels, local: local) : nil,
                               time: time)
        }
    }

    /// The widest time the block may need, so the item keeps its width as
    /// the minutes change instead of nudging its neighbours.
    static func menuBarReservedTime(locale: Locale = .current) -> String {
        uses24HourClock(locale: locale) ? "00:00" : "00:00PM"
    }

    // MARK: - Timeline

    /// A drag distance turned into a whole number of steps, clamped to the
    /// timeline's range.
    static func snappedOffset(minutes: Double) -> Int {
        let step = Double(scrubStepMinutes)
        let snapped = Int((minutes / step).rounded()) * scrubStepMinutes
        return max(-scrubRangeMinutes, min(scrubRangeMinutes, snapped))
    }

    /// The offset a drag lands on. By default dragging right goes forward,
    /// like moving a slider's knob; the option flips it so the strip follows
    /// the finger, the way natural scrolling moves a page.
    static func draggedOffset(from start: Int,
                              translation: Double,
                              pointsPerMinute: Double,
                              dragLeftGoesForward: Bool) -> Int {
        let minutes = translation / pointsPerMinute
        return snappedOffset(minutes: Double(start) + (dragLeftGoesForward ? -minutes : minutes))
    }

    /// "Now", or "+3h", "−1h15" relative to now.
    static func scrubLabel(offsetMinutes: Int, strings: WorldClockFeatureStrings) -> String {
        offsetMinutes == 0 ? strings.now : offsetText(minutes: offsetMinutes)
    }

    // MARK: - Search

    /// Common names that are not the city in any identifier, so typing them
    /// still finds a zone.
    static let aliases: [String: String] = [
        "san francisco": "America/Los_Angeles", "seattle": "America/Los_Angeles",
        "washington": "America/New_York", "boston": "America/New_York", "miami": "America/New_York",
        "atlanta": "America/New_York", "austin": "America/Chicago", "dallas": "America/Chicago",
        "houston": "America/Chicago", "rio de janeiro": "America/Sao_Paulo", "rio": "America/Sao_Paulo",
        "brasilia": "America/Sao_Paulo", "porto": "Europe/Lisbon", "barcelona": "Europe/Madrid",
        "munich": "Europe/Berlin", "frankfurt": "Europe/Berlin", "hamburg": "Europe/Berlin",
        "milan": "Europe/Rome", "geneva": "Europe/Zurich", "edinburgh": "Europe/London",
        "manchester": "Europe/London", "mumbai": "Asia/Kolkata", "delhi": "Asia/Kolkata",
        "new delhi": "Asia/Kolkata", "bangalore": "Asia/Kolkata", "bengaluru": "Asia/Kolkata",
        "beijing": "Asia/Shanghai", "shenzhen": "Asia/Shanghai", "osaka": "Asia/Tokyo",
        "kyoto": "Asia/Tokyo", "abu dhabi": "Asia/Dubai", "tel aviv": "Asia/Jerusalem",
        "saint petersburg": "Europe/Moscow", "st petersburg": "Europe/Moscow",
        "melbourne": "Australia/Melbourne", "canberra": "Australia/Sydney",
        "utc": "UTC", "gmt": "GMT",
    ]

    static func normalized(_ text: String) -> String {
        text.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: Locale(identifier: "en_US_POSIX"))
            .replacingOccurrences(of: "_", with: " ")
            .trimmingCharacters(in: .whitespaces)
    }

    /// Zones whose city, region, abbreviation or alias matches the query:
    /// city prefixes first, then other matches, each group alphabetical.
    static func search(_ query: String,
                       excluding: Set<String> = [],
                       limit: Int = 6,
                       identifiers: [String] = TimeZone.knownTimeZoneIdentifiers) -> [String] {
        let needle = normalized(query)
        guard !needle.isEmpty else { return [] }
        var prefix: [String] = []
        var other: [String] = []
        var seen = excluding
        func add(_ id: String, toPrefix: Bool) {
            guard seen.insert(id).inserted else { return }
            if toPrefix { prefix.append(id) } else { other.append(id) }
        }
        for (alias, id) in aliases.sorted(by: { $0.key < $1.key }) where alias.hasPrefix(needle) {
            add(id, toPrefix: true)
        }
        for id in identifiers.sorted() {
            let city = normalized(cityName(forIdentifier: id))
            if city.hasPrefix(needle) {
                add(id, toPrefix: true)
            } else if city.contains(needle) || normalized(id).contains(needle) {
                add(id, toPrefix: false)
            } else if needle.count >= 3,
                      let abbreviation = TimeZone(identifier: id)?.abbreviation(),
                      normalized(abbreviation) == needle {
                add(id, toPrefix: false)
            }
        }
        return Array((prefix + other).prefix(limit))
    }
}
