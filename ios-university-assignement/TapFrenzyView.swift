//
//  TapFrenzyView.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-06-27.
//

import SwiftUI
import Combine

struct TapFrenzyView: View {

    // my game values
    @State private var score = 0
    @State private var timeLeft = 10
    @State private var gameOver = false

    // high score that is saved even after closing the app
    @AppStorage("tapFrenzyBest") private var bestScore = 0

    // challenge 1 - trap colour. green is good, grey is bad
    @State private var buttonColor = Color.green

    // a timer that fires every 1 second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // another timer to change the button colour every 2 seconds
    let colorTimer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    // challenge 2 - shrinking button. it gets smaller as time runs out
    var buttonSize: CGFloat {
        // when timeLeft is 10 size is 200, when it is 0 size is 80
        return 80 + (CGFloat(timeLeft) * 12)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if gameOver {
                // game over screen
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
                // playing screen
                VStack(spacing: 30) {
                    Text("Time: \(timeLeft)")
                        .font(.title)
                        .foregroundColor(.white)

                    Text("Score: \(score)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    // the big tap button
                    Button("TAP") {
                        // if the button is green you get a point
                        // if it is grey you lose a point (trap)
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
            // count down every second while the game is running
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
            // randomly pick green or grey
            if Bool.random() {
                buttonColor = .green
            } else {
                buttonColor = .gray
            }
        }
    }

    // reset everything so we can play again
    func playAgain() {
        score = 0
        timeLeft = 10
        gameOver = false
    }
}

#Preview {
    TapFrenzyView()
}
