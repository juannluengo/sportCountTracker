import Foundation

struct Match: Identifiable {
    let id = UUID()
    let sport: String
    let pointsP1: Int
    let pointsP2: Int
    let date = Date()
}

class MatchHistory: ObservableObject {
    @Published var matches: [Match] = []
    
    func addMatch(_ match: Match) {
        matches.append(match)
    }
    
    func clearHistory() {
        matches.removeAll()
    }
}
