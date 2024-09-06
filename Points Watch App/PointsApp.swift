//
//  PointsApp.swift
//  Points Watch App
//
//  Created by Danrui Wang on 5/9/24.
//

import SwiftUI

@main
struct PointsApp: App {
    @StateObject var history = MatchHistory() // Shared across views

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(history) // Provide access to match history
        }
    }
}
