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

// the 4 levels of the game
enum Level {
    case l1, l2, l3, l4

    // how many cards on screen
    var cardCount: Int {
        switch self {
        case .l1: return 3
        case .l2: return 4
        case .l3: return 6
        case .l4: return 9
        }
    }

    // how long a card stays lit (in seconds)
    var litWindow: Double {
        switch self {
        case .l1: return 1.5
        case .l2: return 1.2
        case .l3: return 1.0
        case .l4: return 0.8
        }
    }

    // how many cards light up at once
    var litCount: Int {
        if self == .l4 {
            return 2
        } else {
            return 1
        }
    }

    // number of columns in the grid
    var columns: Int {
        switch self {
        case .l1: return 3
        case .l2: return 2
        case .l3: return 3
        case .l4: return 3
        }
    }

    // a different colour for each level
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

    // high score that is saved even after closing the app
    @AppStorage("lightItUpBest") private var bestScore = 0

    // round timer that ticks every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // the columns change depending on the level
    var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: currentLevel.columns)
    }

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
                    // save the high score if this was a new best
                    if score > bestScore {
                        bestScore = score
                    }
                }
            }
        }
        .onAppear {
            startGame()
        }
        .onDisappear {
            // stop the light loop when we leave this screen
            gameOver = true
        }
    }

    // start a fresh round at level 1
    func startGame() {
        score = 0
        timeLeft = 60
        gameOver = false
        currentLevel = .l1
        makeCards()
        runLightLoop()
    }

    // work out which level we should be on by how much time has passed
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

        // if the level changed, build a new grid
        if newLevel != currentLevel {
            currentLevel = newLevel
            makeCards()
        }
    }

    // build the cards array for the current level
    func makeCards() {
        var newCards: [Card] = []
        for _ in 0..<currentLevel.cardCount {
            newCards.append(Card())
        }
        cards = newCards
        lightRandomCards()
    }

    // turn all cards off then light up the right number of random ones
    func lightRandomCards() {
        for i in cards.indices {
            cards[i].isLit = false
        }
        let howMany = min(currentLevel.litCount, cards.count)
        let mixed = cards.indices.shuffled()
        for j in 0..<howMany {
            cards[mixed[j]].isLit = true
        }
    }

    // keep lighting new cards every litWindow seconds
    func runLightLoop() {
        if gameOver {
            return
        }
        lightRandomCards()
        DispatchQueue.main.asyncAfter(deadline: .now() + currentLevel.litWindow) {
            runLightLoop()
        }
    }

    // when a card is tapped
    func tapCard(_ i: Int) {
        if cards[i].isLit {
            score += 1            // correct card
            lightRandomCards()    // show a new one straight away
        } else {
            if score > 0 {
                score -= 1        // wrong card penalty
            }
        }
    }
}

#Preview {
    LightItUpView()
}
