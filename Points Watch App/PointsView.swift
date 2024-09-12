import SwiftUI

struct PointsView: View {
    var sport: String
    @EnvironmentObject var history: MatchHistory
    @State private var pointsP1 = 0
    @State private var pointsP2 = 0
    @State private var setsP1 = 0
    @State private var setsP2 = 0
    @State private var actionHistory: [(pointsP1: Int, pointsP2: Int, setsP1: Int, setsP2: Int)] = []
    
    @State private var animateP1 = false
    @State private var animateP2 = false

    var maxPoints: Int {
        switch sport {
        case "Badminton": return 21
        case "Squash", "Ping Pong": return 11
        case "Tennis", "Padel": return 4
        default: return 10
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                Text("Sets \(setsP1) : \(setsP2)")
                    .font(.title2)
                    .padding()

                HStack {
                    VStack {
                        Text("P1: \(displayScore(points: pointsP1))")
                            .font(.title2)

                        Button(action: {}) {
                            Text("+")
                                .font(.largeTitle)
                                .frame(width: 40, height: 40)
                        }
                        .scaleEffect(animateP1 ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.1), value: animateP1)
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 1.0)
                                .onEnded { _ in
                                    incrementP1()
                                    provideHapticFeedback()
                                    animateButton(for: .p1)
                                }
                        )
                    }
                    VStack {
                        Text("P2: \(displayScore(points: pointsP2))")
                            .font(.title2)

                        Button(action: {}) {
                            Text("+")
                                .font(.largeTitle)
                                .frame(width: 40, height: 40)
                        }
                        .scaleEffect(animateP2 ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.1), value: animateP2)
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 1.0)
                                .onEnded { _ in
                                    incrementP2()
                                    provideHapticFeedback()
                                    animateButton(for: .p2)
                                }
                        )
                    }
                }
                .padding()

                Button(action: redoLastAction) {
                    Text("Undo")
                        .foregroundColor(.orange)
                }
                .padding()

                Button(action: resetMatch) {
                    Text("Finish")
                        .foregroundColor(.red)
                }
                .padding()
            }
        }
        .navigationTitle("\(sport)")
    }
    
    

    private func provideHapticFeedback() {
        WKInterfaceDevice.current().play(.success)
    }

    private func animateButton(for player: Player) {
        switch player {
        case .p1:
            animateP1 = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateP1 = false
            }
        case .p2:
            animateP2 = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateP2 = false
            }
        }
    }
    
    
    

    private enum Player {
        case p1, p2
    }


    // Score display function for Tennis, Padel, and other sports
    func displayScore(points: Int) -> String {
        switch sport {
        case "Tennis", "Padel":
            return tennisPadelScore(points: points)
        case "Badminton", "Squash", "Ping Pong":
            return "\(points)"
        default:
            return "\(points)"
        }
    }

    // Tennis and Padel scoring
    func tennisPadelScore(points: Int) -> String {
        switch points {
        case 0: return "0"
        case 1: return "15"
        case 2: return "30"
        case 3: return "40"
        default:
            if pointsP1 >= 3 && pointsP2 >= 3 {
                if pointsP1 == pointsP2 {
                    return "D" // Deuce
                } else if pointsP1 > pointsP2 {
                    return "A1" // Advantage Player 1
                } else {
                    return "A2" // Advantage Player 2
                }
            }
            return "Game"
        }
    }

    // Increment logic for Player 1
    func incrementP1() {
        saveCurrentState() // Save current state before incrementing
        switch sport {
        case "Tennis", "Padel":
            incrementTennisPadel(player: 1)
        case "Badminton", "Squash", "Ping Pong":
            incrementBadmintonSquashPingPong(player: 1)
        default:
            pointsP1 += 1
        }
    }

    // Increment logic for Player 2
    func incrementP2() {
        saveCurrentState() // Save current state before incrementing
        switch sport {
        case "Tennis", "Padel":
            incrementTennisPadel(player: 2)
        case "Badminton", "Squash", "Ping Pong":
            incrementBadmintonSquashPingPong(player: 2)
        default:
            pointsP2 += 1
        }
    }

    // Tennis/Padel increment logic
    func incrementTennisPadel(player: Int) {
        if player == 1 {
            if pointsP1 == 3 && pointsP2 < 3 {
                winGame(player: 1)
            } else if pointsP1 >= 3 && pointsP2 >= 3 {
                if pointsP1 == pointsP2 {
                    pointsP1 += 1 // Move to Advantage P1
                } else if pointsP1 > pointsP2 {
                    winGame(player: 1)
                } else {
                    pointsP1 += 1 // Back to Deuce
                }
            } else {
                pointsP1 += 1
            }
        } else if player == 2 {
            if pointsP2 == 3 && pointsP1 < 3 {
                winGame(player: 2)
            } else if pointsP2 >= 3 && pointsP1 >= 3 {
                if pointsP2 == pointsP1 {
                    pointsP2 += 1 // Move to Advantage P2
                } else if pointsP2 > pointsP1 {
                    winGame(player: 2)
                } else {
                    pointsP2 += 1 // Back to Deuce
                }
            } else {
                pointsP2 += 1
            }
        }
    }

    // Increment logic for Badminton, Squash, and Ping Pong
    func incrementBadmintonSquashPingPong(player: Int) {
        let maxThreshold = sport == "Badminton" ? 20 : 10 // Deuce threshold for Badminton (20), Squash/Ping Pong (10)
        if player == 1 {
            if pointsP1 >= maxThreshold && pointsP1 - pointsP2 >= 1 {
                winGame(player: 1)
            } else {
                pointsP1 += 1
            }
        } else if player == 2 {
            if pointsP2 >= maxThreshold && pointsP2 - pointsP1 >= 1 {
                winGame(player: 2)
            } else {
                pointsP2 += 1
            }
        }
    }

    // Handling when a player wins a game
    func winGame(player: Int) {
        if player == 1 {
            setsP1 += 1
        } else {
            setsP2 += 1
        }
        resetPoints()
    }

    // Save the current state (both points and sets) before taking an action
    func saveCurrentState() {
        actionHistory.append((pointsP1: pointsP1, pointsP2: pointsP2, setsP1: setsP1, setsP2: setsP2))
    }

    // Redo last action (restore the previous state of points and sets)
    func redoLastAction() {
        guard !actionHistory.isEmpty else { return }
        let lastState = actionHistory.removeLast()
        pointsP1 = lastState.pointsP1
        pointsP2 = lastState.pointsP2
        setsP1 = lastState.setsP1
        setsP2 = lastState.setsP2
    }

    // Reset points after a game is won
    func resetPoints() {
        pointsP1 = 0
        pointsP2 = 0
    }

    // Reset the match
    func resetMatch() {
        history.addMatch(Match(sport: sport, pointsP1: setsP1, pointsP2: setsP2))
        pointsP1 = 0
        pointsP2 = 0
        setsP1 = 0
        setsP2 = 0
        actionHistory.removeAll() // Clear history when resetting the match
    }
}
