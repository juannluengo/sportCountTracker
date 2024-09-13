//
//  ContentView.swift
//  Points Watch App
//
//  Created by Danrui Wang on 5/9/24 .
//

import SwiftUI

struct ContentView: View {
    var sports = ["Tennis", "Badminton", "Ping Pong", "Squash", "Padel"]

    var body: some View {
        NavigationView { // Wrap content in a NavigationView to enable navigation
            ScrollView {
                VStack {
                    Text("Select Sport")
                        .font(.headline) // Smaller font size as per your request
                        .padding()

                    ForEach(sports, id: \.self) { sport in
                        NavigationLink(destination: PointsView(sport: sport)) {
                            Text(sport)
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 5)
                    }

                    NavigationLink(destination: HistoryView()) {
                        Text("History")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true) // Hides the default navigation bar
        }
    }
}
