//
//  ContentView.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-06-27.
//

import SwiftUI

struct ContentView: View {

    // my game values
    @State private var score = 0
    @State private var timeLeft = 10
    @State private var gameOver = false
    @State private var bestScore = 0

    // a timer that fires every 1 second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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
                        score += 1
                    }
                    .font(.system(size: 40))
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 200, height: 200)
                    .background(Color.green)
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
    }

    // reset everything so we can play again
    func playAgain() {
        score = 0
        timeLeft = 10
        gameOver = false
    }
}

#Preview {
    ContentView()
}
