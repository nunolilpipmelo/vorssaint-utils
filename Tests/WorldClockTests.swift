// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

enum WorldClockContract {
    static func run(_ suite: TestSuite) {
        let lisbon = TimeZone(identifier: "Europe/Lisbon")!
        let newYork = TimeZone(identifier: "America/New_York")!
        let kolkata = TimeZone(identifier: "Asia/Kolkata")!
        let tokyo = TimeZone(identifier: "Asia/Tokyo")!
        let posix24 = Locale(identifier: "en_GB")
        let us12 = Locale(identifier: "en_US")
        // 2026-11-13 23:30 UTC: still the 13th in Lisbon, already the 14th in Tokyo.
        let lateEvening = Date(timeIntervalSince1970: 1_794_612_600)
        let strings = FeatureStrings.worldClock(.enUS)

        // Saved lists
        suite.expect(WorldClockSupport.parse("local,Europe/Lisbon,local,Not/AZone, Asia/Tokyo")
                        == ["local", "Europe/Lisbon", "Asia/Tokyo"],
                     "saved zones drop duplicates and unknown identifiers and keep their order")
        suite.expect(WorldClockSupport.parse("") == [], "an empty saved list has no zones")
        suite.expect(WorldClockSupport.menuBarZones(pinned: ["Asia/Tokyo", "local", "Europe/Paris"],
                                                    listed: ["local", "Europe/Lisbon", "Asia/Tokyo"])
                        == ["local", "Asia/Tokyo"],
                     "the menu bar shows listed pins in list order, two at most")
        suite.expect(WorldClockSupport.togglingPin("Asia/Tokyo", in: ["local", "Europe/Lisbon"])
                        == ["Europe/Lisbon", "Asia/Tokyo"],
                     "pinning a third zone drops the oldest pin")
        suite.expect(WorldClockSupport.togglingPin("local", in: ["local", "Europe/Lisbon"]) == ["Europe/Lisbon"],
                     "pinning a pinned zone unpins it")

        // Names
        suite.expect(WorldClockSupport.cityName(forIdentifier: "America/Sao_Paulo") == "Sao Paulo"
                        && WorldClockSupport.cityName(forIdentifier: "America/Argentina/Buenos_Aires") == "Buenos Aires",
                     "city names come from the last part of the identifier")
        suite.expect(WorldClockSupport.shortLabel(for: "America/New_York") == "NY"
                        && WorldClockSupport.shortLabel(for: "Europe/Lisbon") == "LIS",
                     "short labels use initials for several words and three letters otherwise")
        suite.expect(WorldClockSupport.cityName(for: "local", local: tokyo) == "Tokyo",
                     "the local row is named after the Mac's own zone")

        // Your own labels
        let labels = ["America/Sao_Paulo": "🇧🇷 Mãe", "Asia/Tokyo": "Client", "Europe/Paris": "  "]
        suite.expect(WorldClockSupport.menuBarLabel(for: "America/Sao_Paulo", labels: labels) == "🇧🇷 Mãe"
                        && WorldClockSupport.menuBarLabel(for: "Asia/Tokyo", labels: labels) == "Client",
                     "a label of text, an emoji or both is used as typed")
        suite.expect(WorldClockSupport.menuBarLabel(for: "Europe/Paris", labels: labels) == "PAR"
                        && WorldClockSupport.menuBarLabel(for: "America/New_York", labels: labels) == "NY"
                        && WorldClockSupport.customLabel(for: "Europe/Paris", labels: labels) == nil,
                     "without a label, or with a blank one, the city's short label is used")
        suite.expect(WorldClockSupport.cappedLabel("Headquarters") == "Headquar"
                        && WorldClockSupport.cappedLabel("🇧🇷🇵🇹🇯🇵🇺🇸🇫🇷🇩🇪🇮🇹🇪🇸🇬🇧") == "🇧🇷🇵🇹🇯🇵🇺🇸🇫🇷🇩🇪🇮🇹🇪🇸",
                     "labels stop at eight characters, an emoji counting as one")
        suite.expect(WorldClockSupport.cleaned(["Asia/Tokyo": "Team", "Europe/Paris": " ", "Gone/Zone": "x"],
                                               keeping: ["Asia/Tokyo", "Europe/Paris"]) == ["Asia/Tokyo": "Team"],
                     "saved labels drop blanks and removed zones")

        // Formatting
        suite.expect(WorldClockSupport.uses24HourClock(locale: posix24) && !WorldClockSupport.uses24HourClock(locale: us12),
                     "the clock style follows the locale")
        suite.expect(WorldClockSupport.timeString(lateEvening, in: lisbon, locale: posix24) == "23:30",
                     "a 24-hour locale shows 23:30")
        let twelveHour = WorldClockSupport.timeString(lateEvening, in: newYork, locale: us12, compact: true)
        suite.expect(twelveHour == "6:30PM", "a 12-hour locale compacts to 6:30PM in the menu bar (got \(twelveHour))")
        typealias Line = WorldClockSupport.MenuBarLine
        suite.expect(WorldClockSupport.menuBarLines(now: lateEvening, zones: ["local", "Asia/Tokyo"],
                                                    showLabels: true, locale: posix24, local: lisbon)
                        == [Line(label: "LIS", time: "23:30"), Line(label: "TOK", time: "08:30")],
                     "two pinned zones give two lines, each label kept apart from its time")
        suite.expect(WorldClockSupport.menuBarLines(now: lateEvening, zones: ["local", "America/Sao_Paulo"],
                                                    showLabels: true,
                                                    labels: ["local": "🏠", "America/Sao_Paulo": "Mãe"],
                                                    locale: posix24, local: lisbon)
                        == [Line(label: "🏠", time: "23:30"), Line(label: "Mãe", time: "20:30")],
                     "menu bar lines use the custom labels")
        suite.expect(WorldClockSupport.menuBarLines(now: lateEvening, zones: ["Asia/Tokyo"],
                                                    showLabels: false, locale: posix24, local: lisbon)
                        == [Line(label: nil, time: "08:30")]
                        && Line(label: "TOK", time: "08:30").joined == "TOK 08:30",
                     "without labels a line is just the time, and one line joins label and time")
        suite.expect(WorldClockSupport.menuBarReservedTime(locale: posix24) == "00:00"
                        && WorldClockSupport.menuBarReservedTime(locale: us12) == "00:00PM",
                     "the menu bar reserves room for the widest time of the clock style")

        // Offsets and days
        suite.expect(WorldClockSupport.offsetMinutes(of: tokyo, from: lisbon, at: lateEvening) == 9 * 60,
                     "Tokyo is nine hours ahead of Lisbon in November")
        suite.expect(WorldClockSupport.offsetText(minutes: 9 * 60) == "+9h"
                        && WorldClockSupport.offsetText(minutes: -(5 * 60)) == "\u{2212}5h"
                        && WorldClockSupport.offsetText(
                            minutes: WorldClockSupport.offsetMinutes(of: kolkata, from: lisbon, at: lateEvening)) == "+5h30"
                        && WorldClockSupport.offsetText(minutes: 0) == "",
                     "offsets read +9h, −5h, +5h30, and nothing when equal")
        suite.expect(WorldClockSupport.dayShift(at: lateEvening, in: tokyo, comparedWith: lateEvening, localZone: lisbon) == 1
                        && WorldClockSupport.dayShift(at: lateEvening, in: newYork, comparedWith: lateEvening, localZone: lisbon) == 0,
                     "Tokyo is already tomorrow while New York is still today")
        let dragged = lateEvening.addingTimeInterval(3600)
        suite.expect(WorldClockSupport.dayShift(at: dragged, in: lisbon, comparedWith: lateEvening, localZone: lisbon) == 1,
                     "dragging past local midnight makes the local row read tomorrow")
        suite.expect(WorldClockSupport.dayText(shift: 1, strings: strings) == strings.tomorrow
                        && WorldClockSupport.dayText(shift: -1, strings: strings) == strings.yesterday,
                     "day shifts read as tomorrow and yesterday")
        suite.expect(WorldClockSupport.workingRanges(startMinute: 9 * 60, endMinute: 18 * 60) == [540..<1080]
                        && WorldClockSupport.workingRanges(startMinute: 22 * 60, endMinute: 6 * 60 + 30)
                            == [1320..<1440, 0..<390]
                        && WorldClockSupport.workingRanges(startMinute: 0, endMinute: 1440) == [0..<1440]
                        && WorldClockSupport.workingRanges(startMinute: 480, endMinute: 480).isEmpty,
                     "working hours handle a normal day, a night shift, all day and none")
        suite.expect(WorldClockSupport.isWorkingTime(minuteOfDay: 23 * 60, startMinute: 22 * 60, endMinute: 6 * 60)
                        && WorldClockSupport.isWorkingTime(minuteOfDay: 5 * 60 + 59, startMinute: 22 * 60, endMinute: 6 * 60)
                        && !WorldClockSupport.isWorkingTime(minuteOfDay: 6 * 60, startMinute: 22 * 60, endMinute: 6 * 60)
                        && !WorldClockSupport.isWorkingTime(minuteOfDay: 18 * 60)
                        && WorldClockSupport.isWorkingTime(minuteOfDay: 8 * 60 + 45, startMinute: 8 * 60 + 30,
                                                           endMinute: 17 * 60 + 30),
                     "the end is when work stops, minutes count, and it works across midnight")
        let typed = ["9", "09", "930", "0930", "9:30", "9.30", "9h30", " 17 ", "1730"]
            .map { WorldClockSupport.parseTime($0) }
        suite.expect(typed == [540, 540, 570, 570, 570, 570, 570, 1020, 1050],
                     "typed times read hours, hours and minutes, and common separators (got \(typed))")
        suite.expect(WorldClockSupport.parseTime("24:00") == nil
                        && WorldClockSupport.parseTime("24", allowsEndOfDay: true) == 1440
                        && WorldClockSupport.parseTime("25") == nil
                        && WorldClockSupport.parseTime("9:75") == nil
                        && WorldClockSupport.parseTime("9:5") == nil
                        && WorldClockSupport.parseTime("noon") == nil
                        && WorldClockSupport.parseTime("") == nil,
                     "24:00 is only an end, and anything unreadable is refused")
        suite.expect(WorldClockSupport.formatTime(570) == "09:30" && WorldClockSupport.formatTime(1440) == "24:00",
                     "times are tidied to two-digit hours and minutes")
        suite.expect(WorldClockSupport.minuteOfDay(lateEvening, in: lisbon) == 23 * 60 + 30,
                     "the day bar position is minutes since that zone's midnight")

        // Daylight saving: New York changes on 2026-03-08, Lisbon on 2026-03-29.
        let betweenChanges = Date(timeIntervalSince1970: 1_773_835_200) // 2026-03-18 12:00 UTC
        suite.expect(WorldClockSupport.offsetMinutes(of: newYork, from: lisbon, at: betweenChanges) == -(4 * 60),
                     "between the two daylight saving changes New York is only four hours behind")

        // Timeline
        suite.expect(WorldClockSupport.snappedOffset(minutes: 22) == 15
                        && WorldClockSupport.snappedOffset(minutes: -8) == -15
                        && WorldClockSupport.snappedOffset(minutes: 5) == 0,
                     "timeline drags snap to quarter hours")
        suite.expect(WorldClockSupport.snappedOffset(minutes: 10_000) == WorldClockSupport.scrubRangeMinutes
                        && WorldClockSupport.snappedOffset(minutes: -10_000) == -WorldClockSupport.scrubRangeMinutes,
                     "the timeline stops a day either way")
        // Half a point per minute: 30 points is an hour.
        suite.expect(WorldClockSupport.draggedOffset(from: 0, translation: 30, pointsPerMinute: 0.5,
                                                     dragLeftGoesForward: false) == 60
                        && WorldClockSupport.draggedOffset(from: 0, translation: -30, pointsPerMinute: 0.5,
                                                           dragLeftGoesForward: false) == -60,
                     "by default dragging right goes forward and left goes back")
        suite.expect(WorldClockSupport.draggedOffset(from: 0, translation: -30, pointsPerMinute: 0.5,
                                                     dragLeftGoesForward: true) == 60,
                     "with the option on, dragging left goes forward")
        suite.expect(WorldClockSupport.draggedOffset(from: 120, translation: 7, pointsPerMinute: 0.5,
                                                     dragLeftGoesForward: false) == 135,
                     "a drag continues from where the timeline was and snaps to a quarter hour")
        suite.expect(WorldClockSupport.scrubLabel(offsetMinutes: 0, strings: strings) == strings.now
                        && WorldClockSupport.scrubLabel(offsetMinutes: 195, strings: strings) == "+3h15",
                     "the timeline label reads Now or the offset")

        // Search
        let known = ["Europe/Lisbon", "America/Sao_Paulo", "America/Los_Angeles", "Asia/Tokyo", "Europe/London"]
        suite.expect(WorldClockSupport.search("lis", identifiers: known) == ["Europe/Lisbon"],
                     "search matches the start of a city")
        suite.expect(WorldClockSupport.search("são p", identifiers: known) == ["America/Sao_Paulo"],
                     "search ignores accents")
        suite.expect(WorldClockSupport.search("san francisco", identifiers: known) == ["America/Los_Angeles"],
                     "common cities without their own zone find it through an alias")
        suite.expect(WorldClockSupport.search("lis", excluding: ["Europe/Lisbon"], identifiers: known).isEmpty,
                     "zones already listed are not offered again")
        suite.expect(WorldClockSupport.search("  ", identifiers: known).isEmpty, "a blank query finds nothing")

        // Every language has every string filled in.
        for language in AppLanguage.allCases {
            let s = FeatureStrings.worldClock(language)
            let values = [s.title, s.hubDescription, s.panelDescription, s.local, s.now, s.addPlaceholder,
                          s.noMatches, s.today, s.tomorrow, s.yesterday, s.showInMenuBar, s.hideFromMenuBar,
                          s.menuBarLimit, s.remove, s.showLabels, s.timelineHelp,
                          s.reverseDrag, s.labelHelp, s.workingHours,
                          s.workingHoursTo, s.dayBarsHeading, s.menuBarHeading]
            suite.expect(values.allSatisfy { !$0.trimmingCharacters(in: .whitespaces).isEmpty },
                         "world clock strings are complete in \(language.rawValue)")
        }
    }
}
