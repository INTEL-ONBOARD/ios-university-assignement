//
//  LightItUpView.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-06-27.
//

import SwiftUI
import Combine

struct Card: Identifiable {
    let id = UUID()
    var isLit = false
}

// the 4 levels - each one is harder than the last
enum Level {
    case l1, l2, l3, l4

    var cardCount: Int {
        switch self {
        case .l1: return 3
        case .l2: return 4
        case .l3: return 6
        case .l4: return 9
        }
    }

    var litWindow: Double {
        switch self {
        case .l1: return 1.5
        case .l2: return 1.2
        case .l3: return 1.0
        case .l4: return 0.8
        }
    }
//
    var columns: Int {
        switch self {
        case .l1: return 3
        case .l2: return 2
        case .l3: return 3
        case .l4: return 3
        }
    }

    var color: Color {
        switch self {
        case .l1: return .green
        case .l2: return .blue
        case .l3: return .orange
        case .l4: return .red
        }
    }
}

struct LightItUpView: View {

    @State private var cards: [Card] = []
    @State private var score = 0
    @State private var timeLeft = 60
    @State private var gameOver = false
    @State private var currentLevel: Level = .l1
    @State private var viewActive = false
    @AppStorage("lightItUpBest") private var bestScore = 0

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: currentLevel.columns)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if gameOver {
                VStack(spacing: 20) {
                    Text("Round Over")
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
                        startGame()
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            } else {
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

                    LazyVGrid(columns: gridColumns, spacing: 10) {
                        ForEach(cards.indices, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(cards[i].isLit ? currentLevel.color : Color.gray.opacity(0.3))
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
                    changeLevelIfNeeded()
                } else {
                    gameOver = true
                    if score > bestScore {
                        bestScore = score
                    }
                }
            }
        }
        .onAppear {
            if !viewActive {
                viewActive = true
                startGame()
                runLightLoop()
            }
        }
        .onDisappear {
            viewActive = false
        }
    }

    func startGame() {
        score = 0
        timeLeft = 60
        gameOver = false
        currentLevel = .l1
        makeCards()
    }

    // pick the level based on how much time has passed
    func changeLevelIfNeeded() {
        let timePassed = 60 - timeLeft
        var newLevel: Level = .l1
        if timePassed < 15 {
            newLevel = .l1
        } else if timePassed < 30 {
            newLevel = .l2
        } else if timePassed < 45 {
            newLevel = .l3
        } else {
            newLevel = .l4
        }

        if newLevel != currentLevel {
            currentLevel = newLevel
            makeCards()
        }
    }

    func makeCards() {
        var newCards: [Card] = []
        for _ in 0..<currentLevel.cardCount {
            newCards.append(Card())
        }
        cards = newCards
        lightRandomCards()
    }

    func lightRandomCards() {
        if cards.isEmpty {
            return
        }
        for i in cards.indices {
            cards[i].isLit = false
        }
        let r = Int.random(in: 0..<cards.count)
        cards[r].isLit = true
    }

    // light a new card, wait the level's time, then do it again
    func runLightLoop() {
        if !gameOver {
            lightRandomCards()
        }
        if viewActive {
            DispatchQueue.main.asyncAfter(deadline: .now() + currentLevel.litWindow) {
                runLightLoop()
            }
        }
    }

    func tapCard(_ i: Int) {
        if cards[i].isLit {
            score += 1
            lightRandomCards()
        } else {
            if score > 0 {
                score -= 1
            }
        }
    }
}

#Preview {
    LightItUpView()
}
