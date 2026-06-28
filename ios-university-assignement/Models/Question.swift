//
//  Question.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-07-04.
//

import Foundation

// the whole response from the API - it wraps the list of questions
struct TriviaResponse: Codable {
    let results: [TriviaQuestion]
}

// one trivia question from Open Trivia DB
struct TriviaQuestion: Codable {
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]

    // the JSON uses snake_case so map the names over
    enum CodingKeys: String, CodingKey {
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}
