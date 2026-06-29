//
//  QuizRushViewModel.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-07-04.
//

import Foundation
import Combine

// the three states the screen can be in
enum QuizState {
    case loading
    case loaded
    case failed
}

// used to flash the screen green or shake it red
enum AnswerFeedback: Equatable {
    case correct
    case wrong
}

// all the game logic lives here, away from the view
@MainActor
class QuizRushViewModel: ObservableObject {

    @Published var state: QuizState = .loading
    @Published var questionText = ""
    @Published var answers: [String] = []
    @Published var currentIndex = 0
    @Published var score = 0
    @Published var streak = 0
    @Published var finished = false
    @Published var feedback: AnswerFeedback?

    // the top scores, best first
    @Published var leaderboard: [ScoreEntry] = []
    // stops the same round being saved to the board twice
    @Published var savedRound = false
    // the entry we just added, so the view can highlight it
    @Published var lastEntryID: UUID?

    private var questions: [TriviaQuestion] = []
    private var correctAnswer = ""

    private let service = QuizService()
    private let store = LeaderboardStore()

    var bestScore: Int {
        leaderboard.first?.score ?? 0
    }

    var total: Int {
        questions.count
    }

    // load a fresh round of questions
    func load() async {
        state = .loading
        do {
            let fetched = try await service.fetchQuestions()
            questions = fetched
            currentIndex = 0
            score = 0
            streak = 0
            finished = false
            savedRound = false
            lastEntryID = nil
            leaderboard = store.load()
            prepareQuestion()
            state = .loaded
        } catch {
            state = .failed
        }
    }

    // check the answer the player tapped and move on
    func answer(_ choice: String) {
        // ignore extra taps while the feedback is showing
        guard feedback == nil else { return }

        if choice == correctAnswer {
            streak += 1
            score += 10 + streak   // consecutive correct answers give bonus points
            feedback = .correct
        } else {
            streak = 0
            // small penalty but never go below zero
            if score >= 5 {
                score -= 5
            } else {
                score = 0
            }
            feedback = .wrong
        }

        // hold the feedback for a moment, then go to the next question
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            feedback = nil
            goToNext()
        }
    }

    // move to the next question or finish the round
    func goToNext() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
            prepareQuestion()
        } else {
            finished = true
        }
    }

    // set up the current question - decode the text and shuffle the answers
    private func prepareQuestion() {
        guard currentIndex < questions.count else { return }
        let q = questions[currentIndex]

        questionText = decodeHTML(q.question)
        correctAnswer = decodeHTML(q.correctAnswer)

        var all = q.incorrectAnswers.map { decodeHTML($0) }
        all.append(correctAnswer)
        answers = all.shuffled()
    }

    // save the player's initials and score once the round is over
    func saveScore(initials: String) {
        guard !savedRound else { return }

        var clean = initials.trimmingCharacters(in: .whitespaces).uppercased()
        clean = String(clean.prefix(3))
        if clean.isEmpty {
            clean = "YOU"
        }

        let entry = store.add(initials: clean, score: score)
        leaderboard = store.load()
        lastEntryID = entry.id
        savedRound = true
    }

    // the API sends text like &quot; and &#039; so swap those back to real characters
    private func decodeHTML(_ text: String) -> String {
        let entities = [
            "&quot;": "\"",
            "&#039;": "'",
            "&apos;": "'",
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&eacute;": "é",
            "&egrave;": "è",
            "&ntilde;": "ñ",
            "&hellip;": "…",
            "&rsquo;": "'"
        ]
        var result = text
        for (entity, character) in entities {
            result = result.replacingOccurrences(of: entity, with: character)
        }
        return result
    }
}
