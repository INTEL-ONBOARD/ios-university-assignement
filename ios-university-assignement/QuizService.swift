//
//  QuizService.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-07-04.
//

import Foundation

// handles talking to the API - keeps the URL in one place
struct QuizService {

    // 10 multiple choice questions
    let url = URL(string: "https://opentdb.com/api.php?amount=10&type=multiple")!

    // go and fetch the questions, async so it doesn't block the UI
    func fetchQuestions() async throws -> [TriviaQuestion] {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
        return decoded.results
    }
}
