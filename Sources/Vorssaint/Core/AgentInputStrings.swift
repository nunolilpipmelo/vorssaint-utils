// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

/// The AI section’s words for a session waiting on its person.
struct AgentInputStrings {
    let needsYou: String
    let needYouFormat: String
    let noticeTitleFormat: String
    let question: String
    let permission: String
    let waitingFormat: String
    let settingTitle: String
    let settingCaption: String
    let connected: String
    let notConnected: String
    let unreadable: String
    let setUp: String
    let remove: String
    let setupCaption: String
    let setupFailed: String
    let alertTitle: String
    let animationTitle: String
    let classic: String
    let bloom: String
    let snake: String
    let sweep: String
    let gears: String
    let equalizer: String
    let rain: String
    let twinkle: String

    /// "Needs you" for one waiting session, "2 need you" for more.
    func waiting(count: Int) -> String {
        count > 1 ? String(format: needYouFormat, count) : needsYou
    }

    func noticeTitle(_ agent: String) -> String { String(format: noticeTitleFormat, agent) }

    func reason(_ reason: AgentInputRequest.Reason) -> String {
        reason == .permission ? permission : question
    }

    /// A thinking animation's name in the settings menu.
    func animationName(_ id: String) -> String {
        switch id {
        case "bloom": return bloom
        case "snake": return snake
        case "sweep": return sweep
        case "gears": return gears
        case "equalizer": return equalizer
        case "rain": return rain
        case "twinkle": return twinkle
        default: return classic
        }
    }

    func waitingFor(_ duration: String) -> String { String(format: waitingFormat, duration) }
}

extension FeatureStrings {
    static func agentInput(_ language: AppLanguage) -> AgentInputStrings {
        switch language {
        case .enUS: return .enUS
        case .ptBR: return .ptBR
        case .tr: return .tr
        case .ru: return .ru
        case .es: return .es
        case .sk: return .sk
        case .de: return .de
        case .fr: return .fr
        case .it: return .it
        case .ja: return .ja
        case .ko: return .ko
        case .uk: return .uk
        case .zhHans: return .zhHans
        case .zhHK: return .zhHK
        case .zhTW: return .zhTW
        }
    }
}

private extension AgentInputStrings {
    static let enUS = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@",
        settingTitle: "Show when Claude needs you",
        settingCaption: "A question mark and \"Needs you\" while Claude Code waits for an answer or a permission.",
        connected: "Connected to Claude Code",
        notConnected: "Claude Code isn’t connected",
        unreadable: "Claude Code’s settings file couldn’t be read",
        setUp: "Set up",
        remove: "Remove",
        setupCaption: "Set up adds a small hook to Claude Code’s settings so it can tell Vorssaint when it’s waiting. It only shares the session, the reason and the time, never your messages. A backup of the settings is kept.",
        setupFailed: "Couldn’t change Claude Code’s settings.",
        alertTitle: "When Claude needs you",
        animationTitle: "Thinking animation",
        classic: "Classic",
        bloom: "Bloom",
        snake: "Snake",
        sweep: "Sweep",
        gears: "Gears",
        equalizer: "Equalizer",
        rain: "Rain",
        twinkle: "Twinkle"
    )

    static let ptBR = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@",
        settingTitle: "Show when Claude needs you",
        settingCaption: "A question mark and \"Needs you\" while Claude Code waits for an answer or a permission.",
        connected: "Connected to Claude Code",
        notConnected: "Claude Code isn’t connected",
        unreadable: "Claude Code’s settings file couldn’t be read",
        setUp: "Set up",
        remove: "Remove",
        setupCaption: "Set up adds a small hook to Claude Code’s settings so it can tell Vorssaint when it’s waiting. It only shares the session, the reason and the time, never your messages. A backup of the settings is kept.",
        setupFailed: "Couldn’t change Claude Code’s settings.",
        alertTitle: "When Claude needs you",
        animationTitle: "Thinking animation",
        classic: "Classic",
        bloom: "Bloom",
        snake: "Snake",
        sweep: "Sweep",
        gears: "Gears",
        equalizer: "Equalizer",
        rain: "Rain",
        twinkle: "Twinkle"
    )

    static let tr = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@",
        settingTitle: "Show when Claude needs you",
        settingCaption: "A question mark and \"Needs you\" while Claude Code waits for an answer or a permission.",
        connected: "Connected to Claude Code",
        notConnected: "Claude Code isn’t connected",
        unreadable: "Claude Code’s settings file couldn’t be read",
        setUp: "Set up",
        remove: "Remove",
        setupCaption: "Set up adds a small hook to Claude Code’s settings so it can tell Vorssaint when it’s waiting. It only shares the session, the reason and the time, never your messages. A backup of the settings is kept.",
        setupFailed: "Couldn’t change Claude Code’s settings.",
        alertTitle: "When Claude needs you",
        animationTitle: "Thinking animation",
        classic: "Classic",
        bloom: "Bloom",
        snake: "Snake",
        sweep: "Sweep",
        gears: "Gears",
        equalizer: "Equalizer",
        rain: "Rain",
        twinkle: "Twinkle"
    )

    static let ru = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@",
        settingTitle: "Show when Claude needs you",
        settingCaption: "A question mark and \"Needs you\" while Claude Code waits for an answer or a permission.",
        connected: "Connected to Claude Code",
        notConnected: "Claude Code isn’t connected",
        unreadable: "Claude Code’s settings file couldn’t be read",
        setUp: "Set up",
        remove: "Remove",
        setupCaption: "Set up adds a small hook to Claude Code’s settings so it can tell Vorssaint when it’s waiting. It only shares the session, the reason and the time, never your messages. A backup of the settings is kept.",
        setupFailed: "Couldn’t change Claude Code’s settings.",
        alertTitle: "When Claude needs you",
        animationTitle: "Thinking animation",
        classic: "Classic",
        bloom: "Bloom",
        snake: "Snake",
        sweep: "Sweep",
        gears: "Gears",
        equalizer: "Equalizer",
        rain: "Rain",
        twinkle: "Twinkle"
    )

    static let es = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@",
        settingTitle: "Show when Claude needs you",
        settingCaption: "A question mark and \"Needs you\" while Claude Code waits for an answer or a permission.",
        connected: "Connected to Claude Code",
        notConnected: "Claude Code isn’t connected",
        unreadable: "Claude Code’s settings file couldn’t be read",
        setUp: "Set up",
        remove: "Remove",
        setupCaption: "Set up adds a small hook to Claude Code’s settings so it can tell Vorssaint when it’s waiting. It only shares the session, the reason and the time, never your messages. A backup of the settings is kept.",
        setupFailed: "Couldn’t change Claude Code’s settings.",
        alertTitle: "When Claude needs you",
        animationTitle: "Thinking animation",
        classic: "Classic",
        bloom: "Bloom",
        snake: "Snake",
        sweep: "Sweep",
        gears: "Gears",
        equalizer: "Equalizer",
        rain: "Rain",
        twinkle: "Twinkle"
    )

    static let sk = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@",
        settingTitle: "Show when Claude needs you",
        settingCaption: "A question mark and \"Needs you\" while Claude Code waits for an answer or a permission.",
        connected: "Connected to Claude Code",
        notConnected: "Claude Code isn’t connected",
        unreadable: "Claude Code’s settings file couldn’t be read",
        setUp: "Set up",
        remove: "Remove",
        setupCaption: "Set up adds a small hook to Claude Code’s settings so it can tell Vorssaint when it’s waiting. It only shares the session, the reason and the time, never your messages. A backup of the settings is kept.",
        setupFailed: "Couldn’t change Claude Code’s settings.",
        alertTitle: "When Claude needs you",
        animationTitle: "Thinking animation",
        classic: "Classic",
        bloom: "Bloom",
        snake: "Snake",
        sweep: "Sweep",
        gears: "Gears",
        equalizer: "Equalizer",
        rain: "Rain",
        twinkle: "Twinkle"
    )

    static let de = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@",
        settingTitle: "Show when Claude needs you",
        settingCaption: "A question mark and \"Needs you\" while Claude Code waits for an answer or a permission.",
        connected: "Connected to Claude Code",
        notConnected: "Claude Code isn’t connected",
        unreadable: "Claude Code’s settings file couldn’t be read",
        setUp: "Set up",
        remove: "Remove",
        setupCaption: "Set up adds a small hook to Claude Code’s settings so it can tell Vorssaint when it’s waiting. It only shares the session, the reason and the time, never your messages. A backup of the settings is kept.",
        setupFailed: "Couldn’t change Claude Code’s settings.",
        alertTitle: "When Claude needs you",
        animationTitle: "Thinking animation",
        classic: "Classic",
        bloom: "Bloom",
        snake: "Snake",
        sweep: "Sweep",
        gears: "Gears",
        equalizer: "Equalizer",
        rain: "Rain",
        twinkle: "Twinkle"
    )

    static let fr = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@",
        settingTitle: "Show when Claude needs you",
        settingCaption: "A question mark and \"Needs you\" while Claude Code waits for an answer or a permission.",
        connected: "Connected to Claude Code",
        notConnected: "Claude Code isn’t connected",
        unreadable: "Claude Code’s settings file couldn’t be read",
        setUp: "Set up",
        remove: "Remove",
        setupCaption: "Set up adds a small hook to Claude Code’s settings so it can tell Vorssaint when it’s waiting. It only shares the session, the reason and the time, never your messages. A backup of the settings is kept.",
        setupFailed: "Couldn’t change Claude Code’s settings.",
        alertTitle: "When Claude needs you",
        animationTitle: "Thinking animation",
        classic: "Classic",
        bloom: "Bloom",
        snake: "Snake",
        sweep: "Sweep",
        gears: "Gears",
        equalizer: "Equalizer",
        rain: "Rain",
        twinkle: "Twinkle"
    )

    static let it = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@",
        settingTitle: "Show when Claude needs you",
        settingCaption: "A question mark and \"Needs you\" while Claude Code waits for an answer or a permission.",
        connected: "Connected to Claude Code",
        notConnected: "Claude Code isn’t connected",
        unreadable: "Claude Code’s settings file couldn’t be read",
        setUp: "Set up",
        remove: "Remove",
        setupCaption: "Set up adds a small hook to Claude Code’s settings so it can tell Vorssaint when it’s waiting. It only shares the session, the reason and the time, never your messages. A backup of the settings is kept.",
        setupFailed: "Couldn’t change Claude Code’s settings.",
        alertTitle: "When Claude needs you",
        animationTitle: "Thinking animation",
        classic: "Classic",
        bloom: "Bloom",
        snake: "Snake",
        sweep: "Sweep",
        gears: "Gears",
        equalizer: "Equalizer",
        rain: "Rain",
        twinkle: "Twinkle"
    )

    static let ja = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@",
        settingTitle: "Show when Claude needs you",
        settingCaption: "A question mark and \"Needs you\" while Claude Code waits for an answer or a permission.",
        connected: "Connected to Claude Code",
        notConnected: "Claude Code isn’t connected",
        unreadable: "Claude Code’s settings file couldn’t be read",
        setUp: "Set up",
        remove: "Remove",
        setupCaption: "Set up adds a small hook to Claude Code’s settings so it can tell Vorssaint when it’s waiting. It only shares the session, the reason and the time, never your messages. A backup of the settings is kept.",
        setupFailed: "Couldn’t change Claude Code’s settings.",
        alertTitle: "When Claude needs you",
        animationTitle: "Thinking animation",
        classic: "Classic",
        bloom: "Bloom",
        snake: "Snake",
        sweep: "Sweep",
        gears: "Gears",
        equalizer: "Equalizer",
        rain: "Rain",
        twinkle: "Twinkle"
    )

    static let ko = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@",
        settingTitle: "Show when Claude needs you",
        settingCaption: "A question mark and \"Needs you\" while Claude Code waits for an answer or a permission.",
        connected: "Connected to Claude Code",
        notConnected: "Claude Code isn’t connected",
        unreadable: "Claude Code’s settings file couldn’t be read",
        setUp: "Set up",
        remove: "Remove",
        setupCaption: "Set up adds a small hook to Claude Code’s settings so it can tell Vorssaint when it’s waiting. It only shares the session, the reason and the time, never your messages. A backup of the settings is kept.",
        setupFailed: "Couldn’t change Claude Code’s settings.",
        alertTitle: "When Claude needs you",
        animationTitle: "Thinking animation",
        classic: "Classic",
        bloom: "Bloom",
        snake: "Snake",
        sweep: "Sweep",
        gears: "Gears",
        equalizer: "Equalizer",
        rain: "Rain",
        twinkle: "Twinkle"
    )

    static let uk = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@",
        settingTitle: "Show when Claude needs you",
        settingCaption: "A question mark and \"Needs you\" while Claude Code waits for an answer or a permission.",
        connected: "Connected to Claude Code",
        notConnected: "Claude Code isn’t connected",
        unreadable: "Claude Code’s settings file couldn’t be read",
        setUp: "Set up",
        remove: "Remove",
        setupCaption: "Set up adds a small hook to Claude Code’s settings so it can tell Vorssaint when it’s waiting. It only shares the session, the reason and the time, never your messages. A backup of the settings is kept.",
        setupFailed: "Couldn’t change Claude Code’s settings.",
        alertTitle: "When Claude needs you",
        animationTitle: "Thinking animation",
        classic: "Classic",
        bloom: "Bloom",
        snake: "Snake",
        sweep: "Sweep",
        gears: "Gears",
        equalizer: "Equalizer",
        rain: "Rain",
        twinkle: "Twinkle"
    )

    static let zhHans = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@",
        settingTitle: "Show when Claude needs you",
        settingCaption: "A question mark and \"Needs you\" while Claude Code waits for an answer or a permission.",
        connected: "Connected to Claude Code",
        notConnected: "Claude Code isn’t connected",
        unreadable: "Claude Code’s settings file couldn’t be read",
        setUp: "Set up",
        remove: "Remove",
        setupCaption: "Set up adds a small hook to Claude Code’s settings so it can tell Vorssaint when it’s waiting. It only shares the session, the reason and the time, never your messages. A backup of the settings is kept.",
        setupFailed: "Couldn’t change Claude Code’s settings.",
        alertTitle: "When Claude needs you",
        animationTitle: "Thinking animation",
        classic: "Classic",
        bloom: "Bloom",
        snake: "Snake",
        sweep: "Sweep",
        gears: "Gears",
        equalizer: "Equalizer",
        rain: "Rain",
        twinkle: "Twinkle"
    )

    static let zhHK = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@",
        settingTitle: "Show when Claude needs you",
        settingCaption: "A question mark and \"Needs you\" while Claude Code waits for an answer or a permission.",
        connected: "Connected to Claude Code",
        notConnected: "Claude Code isn’t connected",
        unreadable: "Claude Code’s settings file couldn’t be read",
        setUp: "Set up",
        remove: "Remove",
        setupCaption: "Set up adds a small hook to Claude Code’s settings so it can tell Vorssaint when it’s waiting. It only shares the session, the reason and the time, never your messages. A backup of the settings is kept.",
        setupFailed: "Couldn’t change Claude Code’s settings.",
        alertTitle: "When Claude needs you",
        animationTitle: "Thinking animation",
        classic: "Classic",
        bloom: "Bloom",
        snake: "Snake",
        sweep: "Sweep",
        gears: "Gears",
        equalizer: "Equalizer",
        rain: "Rain",
        twinkle: "Twinkle"
    )

    static let zhTW = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@",
        settingTitle: "Show when Claude needs you",
        settingCaption: "A question mark and \"Needs you\" while Claude Code waits for an answer or a permission.",
        connected: "Connected to Claude Code",
        notConnected: "Claude Code isn’t connected",
        unreadable: "Claude Code’s settings file couldn’t be read",
        setUp: "Set up",
        remove: "Remove",
        setupCaption: "Set up adds a small hook to Claude Code’s settings so it can tell Vorssaint when it’s waiting. It only shares the session, the reason and the time, never your messages. A backup of the settings is kept.",
        setupFailed: "Couldn’t change Claude Code’s settings.",
        alertTitle: "When Claude needs you",
        animationTitle: "Thinking animation",
        classic: "Classic",
        bloom: "Bloom",
        snake: "Snake",
        sweep: "Sweep",
        gears: "Gears",
        equalizer: "Equalizer",
        rain: "Rain",
        twinkle: "Twinkle"
    )
}
