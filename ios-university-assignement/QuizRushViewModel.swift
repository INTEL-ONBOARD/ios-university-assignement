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

    private var questions: [TriviaQuestion] = []
    private var correctAnswer = ""

    private let service = QuizService()
    private let bestKey = "quizRushBest"

    var bestScore: Int {
        UserDefaults.standard.integer(forKey: bestKey)
    }

    // how many questions there are, for the "3 of 10" label
    var total: Int {
        questions.count
    }

    // go and load a fresh round of questions
    func load() async {
        state = .loading
        do {
            let fetched = try await service.fetchQuestions()
            questions = fetched
            currentIndex = 0
            score = 0
            streak = 0
            finished = false
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
            saveBest()
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

    private func saveBest() {
        if score > bestScore {
            UserDefaults.standard.set(score, forKey: bestKey)
        }
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
