//
//  LightItUpView.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-06-27.
//

import SwiftUI

// one card in the grid
struct Card: Identifiable {
    let id = UUID()
    var isLit = false
}

struct LightItUpView: View {

    // 9 cards for a 3x3 grid
    @State private var cards = [Card(), Card(), Card(), Card(), Card(),
                               Card(), Card(), Card(), Card()]

    @State private var score = 0
    @State private var timeLeft = 60
    @State private var gameOver = false

    // 3 columns for the grid
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    // one timer that counts the round down and lights up a new card each second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if gameOver {
                // game over screen
                VStack(spacing: 20) {
                    Text("Round Over")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    Text("Score: \(score)")
                        .font(.title)
                        .foregroundColor(.white)

                    Button("Play Again") {
                        playAgain()
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            } else {
                // playing screen
                VStack(spacing: 20) {
                    HStack {
                        Text("Time: \(timeLeft)")
                            .foregroundColor(.white)
                        Spacer()
                        Text("Score: \(score)")
                            .foregroundColor(.white)
                    }
                    .font(.title2)
                    .padding(.horizontal)

                    // the grid of cards
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(cards.indices, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(cards[i].isLit ? Color.blue : Color.gray.opacity(0.3))
                                .frame(height: 90)
                                .onTapGesture {
                                    tapCard(i)
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .onReceive(timer) { _ in
            if !gameOver {
                if timeLeft > 0 {
                    timeLeft -= 1
                    lightUpRandomCard()
                } else {
                    gameOver = true
                }
            }
        }
        .onAppear {
            lightUpRandomCard()
        }
    }

    // turn off all cards and light up one random card
    func lightUpRandomCard() {
        for i in cards.indices {
            cards[i].isLit = false
        }
        let r = Int.random(in: 0..<cards.count)
        cards[r].isLit = true
    }

    // when a card is tapped
    func tapCard(_ i: Int) {
        if cards[i].isLit {
            score += 1            // correct card
            lightUpRandomCard()   // move to a new card
        } else {
            if score > 0 {
                score -= 1        // wrong card penalty
            }
        }
    }

    // start a new round
    func playAgain() {
        score = 0
        timeLeft = 60
        gameOver = false
        lightUpRandomCard()
    }
}

#Preview {
    LightItUpView()
}
