//
//  QuizRushView.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-07-04.
//

import SwiftUI

struct QuizRushView: View {

    @StateObject private var viewModel = QuizRushViewModel()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // show a different screen depending on the state
            switch viewModel.state {
            case .loading:
                ProgressView("Loading questions...")
                    .tint(.white)
                    .foregroundColor(.white)

            case .failed:
                errorView

            case .loaded:
                if viewModel.finished {
                    resultsView
                } else {
                    quizView
                }
            }
        }
        // fetch the questions when the screen appears
        .task {
            await viewModel.load()
        }
    }

    // shown when the network call fails
    var errorView: some View {
        VStack(spacing: 20) {
            Text("Couldn't load the quiz")
                .font(.title2)
                .bold()
                .foregroundColor(.white)

            Text("Check your connection and try again.")
                .foregroundColor(.gray)

            Button("Retry") {
                Task {
                    await viewModel.load()
                }
            }
            .font(.title2)
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding()
    }

    // the actual quiz - question and 4 answers
    var quizView: some View {
        VStack(spacing: 25) {
            HStack {
                Text("\(viewModel.currentIndex + 1) of \(viewModel.total)")
                    .foregroundColor(.white)
                Spacer()
                Text("Streak: \(viewModel.streak)")
                    .foregroundColor(.orange)
            }
            .font(.headline)
            .padding(.horizontal)

            Text("Score: \(viewModel.score)")
                .font(.title2)
                .bold()
                .foregroundColor(.white)

            Text(viewModel.questionText)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding()

            ForEach(viewModel.answers, id: \.self) { answer in
                Button {
                    viewModel.answer(answer)
                } label: {
                    Text(answer)
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(15)
                }
            }
        }
        .padding()
    }

    // shown after the last question
    var resultsView: some View {
        VStack(spacing: 20) {
            Text("Round Over")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)

            Text("Score: \(viewModel.score)")
                .font(.title)
                .foregroundColor(.white)

            Text("Best: \(viewModel.bestScore)")
                .font(.headline)
                .foregroundColor(.gray)

            Button("Play Again") {
                Task {
                    await viewModel.load()
                }
            }
            .font(.title2)
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
}

#Preview {
    QuizRushView()
}
