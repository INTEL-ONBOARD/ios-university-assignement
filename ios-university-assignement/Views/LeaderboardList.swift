//
//  LeaderboardList.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-06-29.
//

import SwiftUI

// shows a list of scores, best first, with an optional highlighted row
struct LeaderboardList: View {

    let entries: [ScoreEntry]
    var highlightID: UUID? = nil

    var body: some View {
        VStack(spacing: 8) {
            ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                HStack {
                    Text("\(index + 1).")
                        .foregroundColor(.gray)
                        .frame(width: 30, alignment: .leading)

                    Text(entry.initials)
                        .bold()
                        .foregroundColor(.white)

                    Spacer()

                    Text("\(entry.score)")
                        .bold()
                        .foregroundColor(.orange)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(entry.id == highlightID ? Color.orange.opacity(0.25) : Color.clear)
                .cornerRadius(8)
            }
        }
    }
}
