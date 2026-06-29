//
//  LeaderboardView.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-06-29.
//

import SwiftUI

// the leaderboard screen reached from the home menu
struct LeaderboardView: View {

    @State private var entries: [ScoreEntry] = []
    private let store = LeaderboardStore()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if entries.isEmpty {
                VStack(spacing: 12) {
                    Text("No scores yet")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)

                    Text("Play a round of Quiz Rush to get on the board!")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                ScrollView {
                    LeaderboardList(entries: entries)
                        .padding()
                }
            }
        }
        .navigationTitle("Leaderboard")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            entries = store.load()
        }
    }
}

#Preview {
    NavigationStack {
        LeaderboardView()
    }
}
