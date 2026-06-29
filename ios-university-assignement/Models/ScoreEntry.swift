//
//  ScoreEntry.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-06-29.
//

import Foundation

// one row on the Quiz Rush leaderboard
struct ScoreEntry: Identifiable, Codable, Equatable {
    let id: UUID
    let initials: String
    let score: Int
    let date: Date

    init(id: UUID = UUID(), initials: String, score: Int, date: Date = Date()) {
        self.id = id
        self.initials = initials
        self.score = score
        self.date = date
    }
}
