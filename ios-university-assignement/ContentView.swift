//
//  ContentView.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-06-27.
//

import SwiftUI

// main menu with a button for each game
struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {

                Text("Mini Games")
                    .font(.largeTitle)
                    .bold()

                NavigationLink {
                    TapFrenzyView()
                } label: {
                    Text("Tap Frenzy")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(15)
                }

                NavigationLink {
                    LightItUpView()
                } label: {
                    Text("Light It Up")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                }

                NavigationLink {
                    QuizRushView()
                } label: {
                    Text("Quiz Rush")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(15)
                }
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}
