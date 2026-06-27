//
//  ContentView.swift
//  ios-university-assignement
//
//  Created by KKwenuja on 2026-06-27.
//

import SwiftUI

// this is the main menu of the app
struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {

                Text("Mini Games")
                    .font(.largeTitle)
                    .bold()

                // button that goes to the first game
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

                // button that goes to the second game
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
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}
