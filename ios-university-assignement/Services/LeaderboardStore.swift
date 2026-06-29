//
//  LeaderboardStore.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-06-29.
//

import Foundation

// saves and loads the Quiz Rush high scores using UserDefaults
struct LeaderboardStore {

    private let key = "quizRushLeaderboard"
    private let maxEntries = 10

    // read the saved scores, best first
    func load() -> [ScoreEntry] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let entries = try? JSONDecoder().decode([ScoreEntry].self, from: data) else {
            return []
        }
        return sortEntries(entries)
    }

    // add a new score, keep only the top ones, and hand back the entry we added
    @discardableResult
    func add(initials: String, score: Int) -> ScoreEntry {
        let entry = ScoreEntry(initials: initials, score: score)
        var entries = load()
        entries.append(entry)
        entries = Array(sortEntries(entries).prefix(maxEntries))
        save(entries)
        return entry
    }

    // highest score first, and if two are equal the earlier one wins
    private func sortEntries(_ entries: [ScoreEntry]) -> [ScoreEntry] {
        entries.sorted {
            if $0.score != $1.score {
                return $0.score > $1.score
            }
            return $0.date < $1.date
        }
    }

    private func save(_ entries: [ScoreEntry]) {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
