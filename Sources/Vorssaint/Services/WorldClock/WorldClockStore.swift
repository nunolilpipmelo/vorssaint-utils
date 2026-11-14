// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation
import Combine

/// The saved list of zones, the ones pinned to the menu bar, and the
/// timeline's current offset. The list lives in UserDefaults, so the menu bar
/// redraws through the same defaults notification every setting uses; the
/// timeline offset is a moment's look ahead and is never saved.
@MainActor
final class WorldClockStore: ObservableObject {
    static let shared = WorldClockStore()

    @Published private(set) var zones: [String]
    @Published private(set) var pinned: [String]
    /// The user's own labels (text, an emoji or both), by zone id.
    @Published private(set) var labels: [String: String]
    /// Minutes the timeline is dragged away from now.
    @Published var scrubOffsetMinutes = 0

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        zones = WorldClockSupport.parse(defaults.string(forKey: DefaultsKey.worldClockZones) ?? "")
        pinned = WorldClockSupport.parse(defaults.string(forKey: DefaultsKey.worldClockMenuBarZones) ?? "")
        labels = defaults.dictionary(forKey: DefaultsKey.worldClockShortLabels) as? [String: String] ?? [:]
        // Names were a separate, short-lived field before labels took their place.
        defaults.removeObject(forKey: "worldClockNames")
    }

    func customLabel(for id: String) -> String? {
        WorldClockSupport.customLabel(for: id, labels: labels)
    }

    /// Capped as it is typed, so the field never holds more than the menu
    /// bar can show. An empty label gives the automatic one back.
    func setLabel(_ id: String, to label: String) {
        labels[id] = WorldClockSupport.cappedLabel(label)
        save()
    }

    var menuBarZones: [String] {
        WorldClockSupport.menuBarZones(pinned: pinned, listed: zones)
    }

    func isPinned(_ id: String) -> Bool {
        menuBarZones.contains(id)
    }

    func add(_ id: String) {
        guard WorldClockSupport.isValid(id), !zones.contains(id) else { return }
        zones.append(id)
        // The first city added next to the local time is the obvious second
        // clock, so it goes straight to the menu bar.
        if menuBarZones.count < WorldClockSupport.maxMenuBarZones {
            pinned = WorldClockSupport.togglingPin(id, in: pinned.filter(zones.contains))
        }
        save()
    }

    func remove(_ id: String) {
        zones.removeAll { $0 == id }
        pinned.removeAll { $0 == id }
        labels[id] = nil
        save()
    }

    func togglePin(_ id: String) {
        pinned = WorldClockSupport.togglingPin(id, in: menuBarZones)
        save()
    }

    /// The order a drag in edit mode settles on. Only a reordering of the
    /// saved zones is accepted, so a stale drag cannot add or drop one.
    func setOrder(_ order: [String]) {
        guard order != zones, Set(order) == Set(zones), order.count == zones.count else { return }
        zones = order
        save()
    }

    func move(_ id: String, by delta: Int) {
        guard let index = zones.firstIndex(of: id) else { return }
        let target = max(0, min(zones.count - 1, index + delta))
        guard target != index else { return }
        zones.remove(at: index)
        zones.insert(id, at: target)
        save()
    }

    func resetTimeline() {
        scrubOffsetMinutes = 0
    }

    private func save() {
        defaults.set(WorldClockSupport.join(zones), forKey: DefaultsKey.worldClockZones)
        defaults.set(WorldClockSupport.join(pinned), forKey: DefaultsKey.worldClockMenuBarZones)
        defaults.set(WorldClockSupport.cleaned(labels, keeping: zones), forKey: DefaultsKey.worldClockShortLabels)
    }
}
