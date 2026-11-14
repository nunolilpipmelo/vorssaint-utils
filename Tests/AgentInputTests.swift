// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Vorssaint

import Foundation

enum AgentInputContract {
    static func run(_ suite: TestSuite) {
        let session = "0f1e2d3c-4b5a-6978-8796-a5b4c3d2e1f0"
        let since = 1_794_612_600.0
        func file(_ json: [String: Any]) -> Data {
            (try? JSONSerialization.data(withJSONObject: json)) ?? Data()
        }
        let question = file(["session_id": session, "reason": "question", "tool": "AskUserQuestion",
                             "cwd": "/Users/me/Projects/Vorssaint", "app": "com.anthropic.claudefordesktop",
                             "since": since])

        // Reading what the hook writes
        let parsed = AgentInputSupport.parse(question, fileName: "\(session).json")
        suite.expect(parsed?.session == session && parsed?.reason == .question
                        && parsed?.project == "Vorssaint" && parsed?.app == "com.anthropic.claudefordesktop"
                        && parsed?.since == Date(timeIntervalSince1970: since),
                     "a hook file becomes a waiting session with its reason, project, app and start")
        let permission = file(["reason": "permission", "tool": "Bash", "cwd": "", "app": "", "since": since])
        let permissionRequest = AgentInputSupport.parse(permission, fileName: "\(session).json")
        suite.expect(permissionRequest?.reason == .permission && permissionRequest?.app == nil
                        && permissionRequest?.project == "",
                     "a permission wait reads as one, and an empty app or folder is left out")
        suite.expect(AgentInputSupport.parse(question, fileName: "not-a-session.json") == nil
                        && AgentInputSupport.parse(question, fileName: "\(session).tmp") == nil
                        && AgentInputSupport.parse(Data("{".utf8), fileName: "\(session).json") == nil
                        && AgentInputSupport.parse(file(["reason": "lunch", "since": since]),
                                                   fileName: "\(session).json") == nil
                        && AgentInputSupport.parse(file(["reason": "question"]), fileName: "\(session).json") == nil,
                     "names that are not session ids, half-written files and unknown reasons are ignored")

        // Matching a live turn, ageing out and announcing
        suite.expect(AgentInputSupport.sessionID(forLog: "/Users/me/.claude/projects/x/\(session).jsonl") == session,
                     "a live turn is matched by its log's file name")
        let request = parsed!
        suite.expect(!AgentInputSupport.isStale(request, now: request.since.addingTimeInterval(3600))
                        && AgentInputSupport.isStale(request, now: request.since.addingTimeInterval(7 * 3600)),
                     "a wait left behind stops counting after six hours")
        let later = AgentInputRequest(session: session, reason: .permission, tool: "Bash", cwd: "",
                                      since: request.since.addingTimeInterval(90), app: nil)
        suite.expect(AgentInputSupport.arrivals([request], after: []) == [request]
                        && AgentInputSupport.arrivals([request], after: [request]).isEmpty
                        && AgentInputSupport.arrivals([later], after: [request]) == [later],
                     "only a new wait is announced, including a second one in the same session")

        // Reading a folder
        let folder = FileManager.default.temporaryDirectory
            .appending(path: "vorssaint-agent-input-\(UUID().uuidString)", directoryHint: .isDirectory)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: folder) }
        let old = "11111111-2222-3333-4444-555555555555"
        try? question.write(to: folder.appending(path: "\(session).json"))
        try? file(["reason": "question", "since": since - 8 * 3600]).write(to: folder.appending(path: "\(old).json"))
        try? Data("{}".utf8).write(to: folder.appending(path: ".\(session).tmp"))
        let read = AgentInputSupport.read(folder: folder, now: Date(timeIntervalSince1970: since + 60))
        suite.expect(read.requests.map(\.session) == [session]
                        && read.stale.map(\.lastPathComponent) == ["\(old).json"],
                     "a folder read keeps current waits and hands back stale files to remove")

        // The strip's words
        let strings = FeatureStrings.agentInput(.enUS)
        suite.expect(strings.waiting(count: 1) == "Needs you" && strings.waiting(count: 2) == "2 need you"
                        && strings.noticeTitle("Claude") == "Claude needs you"
                        && strings.reason(.permission) == "Permission",
                     "the strip and notice read Needs you, 2 need you and Claude needs you")
        for language in AppLanguage.allCases {
            let s = FeatureStrings.agentInput(language)
            let values = [s.needsYou, s.needYouFormat, s.noticeTitleFormat, s.question, s.permission, s.waitingFormat]
            suite.expect(values.allSatisfy { !$0.isEmpty }
                            && s.needYouFormat.contains("%d") && s.noticeTitleFormat.contains("%@")
                            && s.waitingFormat.contains("%@"),
                         "agent input strings are complete in \(language.rawValue)")
        }
    }
}
