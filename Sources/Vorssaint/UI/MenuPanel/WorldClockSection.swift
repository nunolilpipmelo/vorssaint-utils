// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import AppKit
import SwiftUI

/// Panel section listing the saved time zones under a draggable timeline.
/// Dragging the timeline shows every row at that other moment, so "what time
/// is 15:00 here for them" is one drag; the menu bar keeps the real time.
struct WorldClockSection: View {
    @ObservedObject private var l10n = L10n.shared
    @ObservedObject private var store = WorldClockStore.shared
    @AppStorage(DefaultsKey.menuBarWorldClock) private var showInMenuBar = false
    @AppStorage(DefaultsKey.worldClockMenuBarLabels) private var showLabels = false
    @AppStorage(DefaultsKey.worldClockDragLeftForward) private var dragLeftGoesForward = false
    @AppStorage(DefaultsKey.worldClockWorkHoursEnabled) private var workHoursEnabled = true
    @AppStorage(DefaultsKey.worldClockWorkStart) private var workStart = WorldClockSupport.defaultWorkStartMinute
    @AppStorage(DefaultsKey.worldClockWorkEnd) private var workEnd = WorldClockSupport.defaultWorkEndMinute
    @State private var query = ""
    @State private var draggingZone: String?
    var collapsible = true

    private var strings: WorldClockFeatureStrings { FeatureStrings.worldClock(l10n.language) }

    var body: some View {
        // Edit mode works like the other sections: a handle to drag each row
        // into place and a button to remove it.
        PanelSection(.worldClock, title: strings.title, collapsible: collapsible,
                     supportsEditing: true) { editing in
            TimelineView(.everyMinute) { context in
                let now = context.date
                let shown = now.addingTimeInterval(TimeInterval(store.scrubOffsetMinutes * 60))
                VStack(alignment: .leading, spacing: 10) {
                    WorldClockTimeline(offsetMinutes: $store.scrubOffsetMinutes,
                                       label: timelineLabel(shown: shown, now: now),
                                       dragLeftGoesForward: dragLeftGoesForward,
                                       strings: strings)
                    VStack(spacing: 2) {
                        ForEach(store.zones, id: \.self) { id in
                            PanelReorderableItem(item: id,
                                                 isEnabled: editing,
                                                 previewsAsCard: true,
                                                 order: orderBinding,
                                                 dragging: $draggingZone) {
                                WorldClockRow(id: id, shown: shown, now: now, editing: editing,
                                              workRanges: workRanges,
                                              strings: strings)
                            }
                        }
                    }
                    addField(now: now)
                    Divider()
                    options
                }
            }
            .panelCard()
        }
        .onDisappear { store.resetTimeline() }
    }

    /// Nothing is tinted with working hours off.
    private var workRanges: [Range<Int>] {
        workHoursEnabled ? WorldClockSupport.workingRanges(startMinute: workStart, endMinute: workEnd) : []
    }

    private var orderBinding: Binding<[String]> {
        Binding(get: { store.zones }, set: { store.setOrder($0) })
    }

    /// "Now", or the offset and the local time it lands on.
    private func timelineLabel(shown: Date, now: Date) -> String {
        guard store.scrubOffsetMinutes != 0 else { return strings.now }
        let local = TimeZone.current
        let day = WorldClockSupport.dayShift(at: shown, in: local, comparedWith: now, localZone: local)
        let time = WorldClockSupport.timeString(shown, in: local)
        let offset = WorldClockSupport.offsetText(minutes: store.scrubOffsetMinutes)
        return day == 0 ? "\(offset) · \(time)" : "\(offset) · \(WorldClockSupport.dayText(shift: day, strings: strings)) \(time)"
    }

    // MARK: - Adding

    private func addField(now: Date) -> some View {
        let results = WorldClockSupport.search(query, excluding: Set(store.zones))
        return VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: "plus.magnifyingglass")
                    .font(.system(size: 10.5, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 16)
                TextField(strings.addPlaceholder, text: $query)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 11))
                    .onSubmit {
                        if let first = results.first { add(first) }
                    }
            }
            if !query.trimmingCharacters(in: .whitespaces).isEmpty {
                if results.isEmpty {
                    Text(strings.noMatches)
                        .font(.system(size: 10.5))
                        .foregroundStyle(.secondary)
                        .padding(.leading, 22)
                } else {
                    VStack(spacing: 0) {
                        ForEach(results, id: \.self) { id in
                            searchResult(id, now: now)
                        }
                    }
                    .padding(.leading, 16)
                }
            }
        }
    }

    private func searchResult(_ id: String, now: Date) -> some View {
        let zone = WorldClockSupport.timeZone(for: id)
        return Button {
            add(id)
        } label: {
            HStack(spacing: 6) {
                Text(WorldClockSupport.cityName(forIdentifier: id))
                    .font(.system(size: 11.5, weight: .medium))
                Text(id.split(separator: "/").dropLast().joined(separator: " / ").replacingOccurrences(of: "_", with: " "))
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Spacer(minLength: 4)
                Text(WorldClockSupport.timeString(now, in: zone))
                    .font(.system(size: 10.5, weight: .semibold).monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 3)
            .padding(.horizontal, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func add(_ id: String) {
        store.add(id)
        query = ""
    }

    // MARK: - Options

    /// Two small groups, every row the same height, so the gaps stay even
    /// whichever boxes are ticked.
    private var options: some View {
        VStack(alignment: .leading, spacing: 10) {
            optionGroup(strings.dayBarsHeading) {
                workingHoursRow
                Toggle(strings.reverseDrag, isOn: $dragLeftGoesForward)
                    .frame(height: Self.optionRowHeight)
            }
            optionGroup(strings.menuBarHeading) {
                Toggle(strings.showInMenuBar, isOn: $showInMenuBar)
                    .frame(height: Self.optionRowHeight)
                Toggle(strings.showLabels, isOn: $showLabels)
                    .frame(height: Self.optionRowHeight)
                    .disabled(!showInMenuBar)
                Text(strings.menuBarLimit)
                    .font(.system(size: 9.5))
                    .foregroundStyle(.secondary)
                    .padding(.leading, 20)
            }
        }
        .font(.system(size: 11.5, weight: .medium))
        .toggleStyle(.checkbox)
        .controlSize(.small)
    }

    private static let optionRowHeight: CGFloat = 20

    private func optionGroup<Content: View>(_ title: String,
                                            @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.system(size: 9.5, weight: .semibold))
                .kerning(0.4)
                .foregroundStyle(.secondary)
            content()
        }
    }

    /// The times sit right after the label. Off, they stay in place but
    /// greyed, so ticking the box moves nothing; they can still be edited.
    private var workingHoursRow: some View {
        HStack(spacing: 6) {
            Toggle(strings.workingHours, isOn: $workHoursEnabled)
            WorldClockTimeField(minutes: $workStart, allowsEndOfDay: false,
                                label: strings.workingHours, dimmed: !workHoursEnabled)
            Text(strings.workingHoursTo)
                .font(.system(size: 11))
                .foregroundStyle(workHoursEnabled ? .secondary : .tertiary)
            WorldClockTimeField(minutes: $workEnd, allowsEndOfDay: true,
                                label: strings.workingHours, dimmed: !workHoursEnabled)
        }
        .frame(height: Self.optionRowHeight)
    }
}

// MARK: - Row

private struct WorldClockRow: View {
    @ObservedObject private var store = WorldClockStore.shared
    let id: String
    let shown: Date
    let now: Date
    let editing: Bool
    let workRanges: [Range<Int>]
    let strings: WorldClockFeatureStrings
    @State private var hovering = false

    var body: some View {
        let local = TimeZone.current
        let zone = WorldClockSupport.timeZone(for: id, local: local)
        let isLocal = id == WorldClockSupport.localID
        let day = WorldClockSupport.dayShift(at: shown, in: zone, comparedWith: now, localZone: local)
        let offset = WorldClockSupport.offsetText(
            minutes: WorldClockSupport.offsetMinutes(of: zone, from: local, at: shown))
        let pinned = store.isPinned(id)

        // One line on top, the day bar under the whole row. Edit mode keeps
        // the city in full and puts a small label field just before the time.
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center, spacing: 6) {
                if editing {
                    PanelDragHandle()
                    Text(WorldClockSupport.cityName(for: id, local: local))
                        .font(.system(size: 11.5, weight: .semibold))
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer(minLength: 4)
                    labelEditor
                } else {
                    VStack(alignment: .leading, spacing: 1) {
                        HStack(spacing: 5) {
                            Text(WorldClockSupport.cityName(for: id, local: local))
                                .font(.system(size: 11.5, weight: .semibold))
                                .lineLimit(1)
                            if let label = store.customLabel(for: id) {
                                WorldClockLabelTag(text: label)
                            }
                        }
                        Text(caption(day: day, offset: offset, isLocal: isLocal))
                            .font(.system(size: 9.5))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    Spacer(minLength: 4)
                    Button {
                        store.togglePin(id)
                    } label: {
                        Image(systemName: pinned ? "menubar.arrow.up.rectangle" : "menubar.rectangle")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(pinned ? Color.accentColor : Color.secondary)
                            .frame(width: 20, height: 20)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .opacity(pinned || hovering ? 1 : 0.35)
                    .help(pinned ? strings.hideFromMenuBar : strings.showInMenuBar)
                }
                Text(WorldClockSupport.timeString(shown, in: zone))
                    .font(.system(size: 15, weight: .semibold).monospacedDigit())
                    .foregroundStyle(store.scrubOffsetMinutes == 0 ? Color.primary : Color.accentColor)
                    .frame(minWidth: 52, alignment: .trailing)
                if editing {
                    WorldClockRemoveButton(title: strings.remove) { store.remove(id) }
                }
            }
            WorldClockDayBar(minuteOfDay: WorldClockSupport.minuteOfDay(shown, in: zone),
                             workRanges: workRanges)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 6)
        .background(
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(Color.primary.opacity(hovering ? 0.05 : 0))
        )
        .onHover { hovering = $0 }
        .contextMenu {
            Button(pinned ? strings.hideFromMenuBar : strings.showInMenuBar) { store.togglePin(id) }
            Divider()
            Button {
                store.move(id, by: -1)
            } label: {
                Label(FeatureStrings.mixer(L10n.shared.language).moveUp, systemImage: "arrow.up")
            }
            .disabled(store.zones.first == id)
            Button {
                store.move(id, by: 1)
            } label: {
                Label(FeatureStrings.mixer(L10n.shared.language).moveDown, systemImage: "arrow.down")
            }
            .disabled(store.zones.last == id)
            Divider()
            Button(strings.remove, role: .destructive) { store.remove(id) }
        }
    }

    private func caption(day: Int, offset: String, isLocal: Bool) -> String {
        let dayText = WorldClockSupport.dayText(shift: day, strings: strings)
        if isLocal { return "\(strings.local) · \(dayText)" }
        return offset.isEmpty ? dayText : "\(dayText) · \(offset)"
    }

    /// The row's own label: text, an emoji or both, capped as it is typed.
    /// Empty, it shows the automatic label the menu bar would use.
    private var labelEditor: some View {
        TextField(WorldClockSupport.shortLabel(for: id),
                  text: Binding(get: { store.labels[id] ?? "" },
                                set: { store.setLabel(id, to: $0) }))
            .textFieldStyle(.roundedBorder)
            .font(.system(size: 11))
            .frame(width: 72)
            .help(strings.labelHelp)
            .accessibilityLabel(strings.labelHelp)
    }
}

/// The user's label beside the city name.
private struct WorldClockLabelTag: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .lineLimit(1)
            .padding(.horizontal, 6)
            .padding(.vertical, 1.5)
            .background(Capsule().fill(Color.accentColor.opacity(0.18)))
            .foregroundStyle(Color.primary)
    }
}

/// A time typed as "9", "930" or "9:30", tidied to "09:30" on Return or
/// when focus leaves; anything unreadable goes back to the last good time.
private struct WorldClockTimeField: View {
    @Binding var minutes: Int
    let allowsEndOfDay: Bool
    let label: String
    var dimmed = false
    @State private var text = ""
    @FocusState private var focused: Bool

    var body: some View {
        TextField("00:00", text: $text)
            .textFieldStyle(.plain)
            .font(.system(size: 11).monospacedDigit())
            .multilineTextAlignment(.center)
            .foregroundStyle(dimmed && !focused ? Color.secondary : Color.primary)
            .frame(width: 40, height: 18)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(Color.primary.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .strokeBorder(focused ? Color.accentColor : Color.primary.opacity(0.15),
                                  lineWidth: focused ? 1.5 : 0.5)
            )
            .focused($focused)
            .onAppear { text = WorldClockSupport.formatTime(minutes) }
            .onSubmit(commit)
            .onChange(of: focused) { _, isFocused in
                if !isFocused { commit() }
            }
            .onChange(of: minutes) { _, value in
                if !focused { text = WorldClockSupport.formatTime(value) }
            }
            .accessibilityLabel(label)
    }

    private func commit() {
        if let value = WorldClockSupport.parseTime(text, allowsEndOfDay: allowsEndOfDay) {
            minutes = value
        }
        text = WorldClockSupport.formatTime(minutes)
    }
}

/// The zone's day from midnight to midnight, working hours lighter, with a
/// marker on the time being shown.
private struct WorldClockDayBar: View {
    let minuteOfDay: Int
    /// Minute ranges tinted as working time; empty with working hours off.
    let workRanges: [Range<Int>]

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let x = width * CGFloat(minuteOfDay) / CGFloat(24 * 60)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.primary.opacity(0.08))
                ForEach(workRanges, id: \.lowerBound) { range in
                    Rectangle()
                        .fill(Color.accentColor.opacity(0.28))
                        .frame(width: width * CGFloat(range.count) / CGFloat(WorldClockSupport.minutesPerDay))
                        .offset(x: width * CGFloat(range.lowerBound) / CGFloat(WorldClockSupport.minutesPerDay))
                }
                RoundedRectangle(cornerRadius: 1)
                    .fill(workRanges.contains { $0.contains(minuteOfDay) }
                          ? Color.accentColor : Color.secondary)
                    .frame(width: 2.5, height: 8)
                    .offset(x: min(max(0, x - 1.25), width - 2.5))
            }
            .frame(height: 8)
            .clipShape(Capsule())
        }
        .frame(height: 8)
        .accessibilityHidden(true)
    }
}

// MARK: - Timeline

/// A strip of quarter-hour ticks under a fixed marker. Dragging right moves
/// into the future (or left, with the option on); each quarter hour clicks on
/// a Force Touch trackpad. Double-click returns to now.
private struct WorldClockTimeline: View {
    @Binding var offsetMinutes: Int
    let label: String
    let dragLeftGoesForward: Bool
    let strings: WorldClockFeatureStrings
    @State private var dragStartOffset: Int?

    /// Horizontal points per minute: an hour spans 30 points.
    private let pointsPerMinute: CGFloat = 0.5

    var body: some View {
        VStack(spacing: 3) {
            HStack(spacing: 6) {
                Spacer(minLength: 0)
                Text(label)
                    .font(.system(size: 11, weight: .semibold).monospacedDigit())
                    .foregroundStyle(offsetMinutes == 0 ? Color.primary : Color.accentColor)
                Spacer(minLength: 0)
            }
            .overlay(alignment: .trailing) {
                if offsetMinutes != 0 {
                    Button(strings.now) { offsetMinutes = 0 }
                        .buttonStyle(.link)
                        .font(.system(size: 10.5, weight: .medium))
                }
            }
            Canvas { context, size in
                drawTicks(in: &context, size: size)
            }
            .frame(height: 20)
            .contentShape(Rectangle())
            .gesture(drag)
            .onTapGesture(count: 2) { offsetMinutes = 0 }
            .help(strings.timelineHelp)
            .accessibilityElement()
            .accessibilityLabel(strings.timelineHelp)
            .accessibilityValue(label)
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment:
                    offsetMinutes = WorldClockSupport.snappedOffset(
                        minutes: Double(offsetMinutes + WorldClockSupport.scrubStepMinutes))
                case .decrement:
                    offsetMinutes = WorldClockSupport.snappedOffset(
                        minutes: Double(offsetMinutes - WorldClockSupport.scrubStepMinutes))
                @unknown default:
                    break
                }
            }
        }
    }

    private var drag: some Gesture {
        DragGesture(minimumDistance: 1)
            .onChanged { value in
                let start = dragStartOffset ?? offsetMinutes
                if dragStartOffset == nil { dragStartOffset = start }
                let next = WorldClockSupport.draggedOffset(from: start,
                                                           translation: Double(value.translation.width),
                                                           pointsPerMinute: Double(pointsPerMinute),
                                                           dragLeftGoesForward: dragLeftGoesForward)
                if next != offsetMinutes {
                    offsetMinutes = next
                    NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .now)
                }
            }
            .onEnded { _ in dragStartOffset = nil }
    }

    /// Ticks every quarter hour, taller on the hour; the past is dimmed and
    /// the marker in the middle is the moment being shown.
    private func drawTicks(in context: inout GraphicsContext, size: CGSize) {
        let center = size.width / 2
        let step = CGFloat(WorldClockSupport.scrubStepMinutes) * pointsPerMinute
        let currentMinute = Calendar.current.component(.minute, from: Date())
        // Ticks sit on real quarter hours, so the strip is shifted by how far
        // now is past the last one.
        let phase = CGFloat(currentMinute % WorldClockSupport.scrubStepMinutes) * pointsPerMinute
        let shift = CGFloat(offsetMinutes) * pointsPerMinute + phase
        let firstIndex = Int(((-center + shift) / step).rounded(.down)) - 1
        let lastIndex = Int(((size.width - center + shift) / step).rounded(.up)) + 1
        let hourStepIndex = 60 / WorldClockSupport.scrubStepMinutes
        let quarterAtNow = (currentMinute / WorldClockSupport.scrubStepMinutes) % hourStepIndex

        for index in firstIndex...max(firstIndex, lastIndex) {
            let x = center + CGFloat(offsetMinutes) * -pointsPerMinute + CGFloat(index) * step - phase
            guard x >= 0, x <= size.width else { continue }
            let isHour = (index + quarterAtNow) % hourStepIndex == 0
            let isPast = CGFloat(index) * step - phase < 0
            let height: CGFloat = isHour ? 12 : 6
            let distance = abs(x - center) / max(1, center)
            let opacity = (isPast ? 0.25 : 0.55) * Double(1 - distance * 0.7)
            let rect = CGRect(x: x - 0.5, y: (size.height - height) / 2, width: 1, height: height)
            context.fill(Path(rect), with: .color(.primary.opacity(opacity)))
        }

        // Where "now" sits on the strip once dragged away from it.
        let nowX = center - CGFloat(offsetMinutes) * pointsPerMinute
        if offsetMinutes != 0, nowX >= 0, nowX <= size.width {
            let dot = CGRect(x: nowX - 2, y: size.height - 4, width: 4, height: 4)
            context.fill(Path(ellipseIn: dot), with: .color(.secondary))
        }

        let marker = CGRect(x: center - 1, y: 0, width: 2, height: size.height)
        context.fill(Path(roundedRect: marker, cornerRadius: 1), with: .color(.accentColor))
    }
}

/// The edit-mode remove button, shaped like the panel's other inline row
/// buttons so it sits where the System section puts its hide button.
private struct WorldClockRemoveButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "trash.fill")
                .font(.system(size: 10.5, weight: .bold))
                .foregroundStyle(Color.red.opacity(0.9))
                .frame(width: 24, height: 22)
                .background(
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .fill(Color.red.opacity(0.12))
                )
        }
        .buttonStyle(.plain)
        .help(title)
        .accessibilityLabel(title)
    }
}
