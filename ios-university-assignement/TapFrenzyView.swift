//
//  TapFrenzyView.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-06-27.
//

import SwiftUI
import Combine

struct TapFrenzyView: View {

    @State private var score = 0
    @State private var timeLeft = 10
    @State private var gameOver = false
    @State private var buttonColor = Color.green
    @AppStorage("tapFrenzyBest") private var bestScore = 0

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let colorTimer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    // challenge 2 - button shrinks as time runs out
    var buttonSize: CGFloat {
        return 80 + (CGFloat(timeLeft) * 12)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if gameOver {
                VStack(spacing: 20) {
                    Text("Time's Up!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    Text("Score: \(score)")
                        .font(.title)
                        .foregroundColor(.white)

                    Text("Best: \(bestScore)")
                        .font(.headline)
                        .foregroundColor(.gray)

                    Button("Play Again") {
                        playAgain()
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            } else {
                VStack(spacing: 30) {
                    Text("Time: \(timeLeft)")
                        .font(.title)
                        .foregroundColor(.white)

                    Text("Score: \(score)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    // challenge 1 - green gives a point, grey takes one away
                    Button("TAP") {
                        if buttonColor == .green {
                            score += 1
                        } else {
                            if score > 0 {
                                score -= 1
                            }
                        }
                    }
                    .font(.system(size: 40))
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: buttonSize, height: buttonSize)
                    .background(buttonColor)
                    .clipShape(Circle())
                }
            }
        }
        .onReceive(timer) { _ in
            if !gameOver {
                if timeLeft > 0 {
                    timeLeft -= 1
                } else {
                    gameOver = true
                    if score > bestScore {
                        bestScore = score
                    }
                }
            }
        }
        .onReceive(colorTimer) { _ in
            if Bool.random() {
                buttonColor = .green
            } else {
                buttonColor = .gray
            }
        }
    }

    func playAgain() {
        score = 0
        timeLeft = 10
        gameOver = false
    }
}

#Preview {
    TapFrenzyView()
}
