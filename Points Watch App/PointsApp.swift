// PointsApp.swift

// Import the SwiftUI framework
import SwiftUI

// Define the main application structure
@main
struct PointsApp: App {
    // Create a shared instance of MatchHistory using @StateObject
    // This will be passed throughout the app via environmentObject
    @StateObject var history = MatchHistory()

    // Define the main scene of the app
    var body: some Scene {
        WindowGroup {
            // Set ContentView as the initial view
            ContentView()
                // Inject the MatchHistory object into the environment
                .environmentObject(history)
        }
    }
}
