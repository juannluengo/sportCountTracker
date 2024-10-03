// Match.swift

// Import the Foundation framework for basic types
import Foundation

// Define the Match struct to represent a match record
struct Match: Identifiable {
    // Unique identifier for the match
    let id = UUID()
    // Sport type
    let sport: String
    // Points or sets for Player 1 and Player 2
    let pointsP1: Int
    let pointsP2: Int
    var matchType: MatchSetupView.MatchType
    var avatars: [String]
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
               matches.removeFirst() // Remove the oldest match
           }
       }
    
    // Function to clear the match history
    func clearHistory() {
        matches.removeAll()
    }
}
