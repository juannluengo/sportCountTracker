// Import the Foundation framework for basic types
import Foundation

// Define the Match struct to represent a match record
struct Match: Identifiable {
    // Unique identifier for the match
    let id = UUID()
    
    // Match details
    let sport: String                    // Sport type
    let pointsP1: Int                    // Points or sets for Player 1
    let pointsP2: Int                    // Points or sets for Player 2
    var matchType: MatchSetupView.MatchType // Type of match (1 vs 1 or 2 vs 2)
    var avatars: [String]                // Avatars representing players
    
    // Date when the match was recorded
    let date = Date()
}

// Define the MatchHistory class to manage match records
class MatchHistory: ObservableObject {
    // Published array of matches to notify views of changes
    @Published var matches: [Match] = []
    
    // Function to add a new match to the history
    func addMatch(_ match: Match) {
        matches.append(match)
        if matches.count > 20 {
            matches.removeFirst() // Remove the oldest match if the history exceeds 20
        }
    }
    
    // Function to clear all match records from the history
    func clearHistory() {
        matches.removeAll()
    }
}
