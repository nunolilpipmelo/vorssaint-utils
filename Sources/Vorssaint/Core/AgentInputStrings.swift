// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

/// The AI section's words for a session waiting on its person.
struct AgentInputStrings {
    let needsYou: String
    let needYouFormat: String
    let noticeTitleFormat: String
    let question: String
    let permission: String
    let waitingFormat: String

    /// "Needs you" for one waiting session, "2 need you" for more.
    func waiting(count: Int) -> String {
        count > 1 ? String(format: needYouFormat, count) : needsYou
    }

    func noticeTitle(_ agent: String) -> String { String(format: noticeTitleFormat, agent) }

    func reason(_ reason: AgentInputRequest.Reason) -> String {
        reason == .permission ? permission : question
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
        waitingFormat: "waiting %@"
    )

    static let ptBR = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@"
    )

    static let tr = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@"
    )

    static let ru = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@"
    )

    static let es = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@"
    )

    static let sk = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@"
    )

    static let de = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@"
    )

    static let fr = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@"
    )

    static let it = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@"
    )

    static let ja = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@"
    )

    static let ko = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@"
    )

    static let uk = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@"
    )

    static let zhHans = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@"
    )

    static let zhHK = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@"
    )

    static let zhTW = AgentInputStrings(
        needsYou: "Needs you",
        needYouFormat: "%d need you",
        noticeTitleFormat: "%@ needs you",
        question: "Question",
        permission: "Permission",
        waitingFormat: "waiting %@"
    )
}
