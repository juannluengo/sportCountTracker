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
