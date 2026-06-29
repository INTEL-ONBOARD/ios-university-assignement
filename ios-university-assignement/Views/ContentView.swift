//
//  ContentView.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-06-27.
//

import SwiftUI

// main menu with a card for each game
struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 18) {

                    // header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Mini Games")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)

                        Text("Three ways to play")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)

                    NavigationLink {
                        TapFrenzyView()
                    } label: {
                        GameCard(title: "Tap Frenzy",
                                 subtitle: "Beat the clock",
                                 icon: "hand.tap.fill",
                                 color: .green)
                    }

                    NavigationLink {
                        LightItUpView()
                    } label: {
                        GameCard(title: "Light It Up",
                                 subtitle: "Hit the lit tiles",
                                 icon: "lightbulb.fill",
                                 color: .blue)
                    }

                    NavigationLink {
                        QuizRushView()
                    } label: {
                        GameCard(title: "Quiz Rush",
                                 subtitle: "Live trivia round",
                                 icon: "questionmark.circle.fill",
                                 color: .orange)
                    }

                    Spacer()
                }
                .padding()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }
}

// one game button on the menu
struct GameCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {

            // coloured icon tile
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 52, height: 52)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(color.opacity(0.6), lineWidth: 1)
        )
        // soft glow in the game's colour
        .shadow(color: color.opacity(0.5), radius: 8)
    }
}

#Preview {
    ContentView()
}
