import SwiftUI

struct PointsView: View {
    var sport: String
    @EnvironmentObject var history: MatchHistory

    // Default colors for players
    let p1Color: Color = .blue
    let p2Color: Color = .red

    @State private var pointsP1 = 0
    @State private var pointsP2 = 0
    @State private var setsP1 = 0
    @State private var setsP2 = 0
    @State private var actionHistory: [(pointsP1: Int, pointsP2: Int, setsP1: Int, setsP2: Int)] = []

    @State private var animateP1 = false
    @State private var animateP2 = false
    @State private var animateFinish = false

    @AppStorage("longPressEnabled") private var longPressEnabled = true

    // The color of the top rectangle is based on who's winning. A tie is a mix of both
    var topColor: Color {
        if pointsP1 > pointsP2 {
            return p1Color
        } else if pointsP2 > pointsP1 {
            return p2Color
        } else {
            return p1Color.blend(with: p2Color)
        }
    }

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
            VStack(spacing: 10) {
                // Top rectangle
                Text("\(setsP1) : \(setsP2)")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(topColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding([.leading, .trailing])

                // Separate rectangles
                Spacer(minLength: 10)

                // Player Rectangles
                HStack(spacing: 10) {
                    // Player 1
                    VStack {
                        Spacer()
                        Text("\(displayScore(points: pointsP1))")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .scaleEffect(animateP1 ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.1), value: animateP1)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(p1Color)
                    .cornerRadius(10)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.height < 0 {
                                    incrementP1()
                                    provideHapticFeedback()
                                    animateButton(for: .p1)
                                } else if value.translation.height > 0 {
                                    decrementP1()
                                    provideHapticFeedback()
                                    animateButton(for: .p1)
                                }
                            }
                    )
                    .onTapGesture {
                        incrementP1()
                        provideHapticFeedback()
                        animateButton(for: .p1)
                    }

                    // Player 2
                    VStack {
                        Spacer()
                        Text("\(displayScore(points: pointsP2))")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .scaleEffect(animateP2 ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.1), value: animateP2)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(p2Color)
                    .cornerRadius(10)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.height < 0 {
                                    incrementP2()
                                    provideHapticFeedback()
                                    animateButton(for: .p2)
                                } else if value.translation.height > 0 {
                                    decrementP2()
                                    provideHapticFeedback()
                                    animateButton(for: .p2)
                                }
                            }
                    )
                    .onTapGesture {
                        incrementP2()
                        provideHapticFeedback()
                        animateButton(for: .p2)
                    }
                }
                .padding([.leading, .trailing])
                .frame(height: 300) // This is to make the players rectangles longer

                // This is to push the buttons lower
                Spacer()

                // Undo Button
                Button(action: redoLastAction) {
                    Text("Undo")
                        .foregroundColor(.orange)
                }
                .padding()

                // Finish Button
                Button(action: {
                    if !longPressEnabled {
                        resetMatch()
                        provideHapticFeedback()
                        animateButton(for: .finish)
                    }
                }) {
                    Text("Finish")
                        .foregroundColor(.red)
                        .frame(width: 80, height: 40)
                }
                .scaleEffect(animateFinish ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: animateFinish)
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 2.0)
                        .onEnded { _ in
                            if longPressEnabled {
                                resetMatch()
                                provideHapticFeedback()
                                animateButton(for: .finish)
                            }
                        }
                )
                .padding()
            }
        }
        // .navigationTitle("\(sport)")
    }

    // Haptic feedback (que vibre cuando pinchas)
    private func provideHapticFeedback() {
        WKInterfaceDevice.current().play(.success)
    }

    // Animate button (so that is slightly increase to show you that you have pressed it)
    private func animateButton(for button: ButtonType) {
        switch button {
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
        case .finish:
            animateFinish = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateFinish = false
            }
        }
    }

    private enum ButtonType {
        case p1, p2, finish
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

    // Decrement logic for Player 1
    func decrementP1() {
        if pointsP1 > 0 {
            saveCurrentState()
            pointsP1 -= 1
        }
    }

    // Decrement logic for Player 2
    func decrementP2() {
        if pointsP2 > 0 {
            saveCurrentState()
            pointsP2 -= 1
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
        let maxThreshold = sport == "Badminton" ? 20 : 10 // Deuce threshold
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

    // Save the current state before taking an action
    func saveCurrentState() {
        actionHistory.append((pointsP1: pointsP1, pointsP2: pointsP2, setsP1: setsP1, setsP2: setsP2))
    }

    // Undo last action
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

// Extension to blend two colors
extension Color {
    func blend(with color: Color) -> Color {
        let uiColor1 = UIColor(self)
        let uiColor2 = UIColor(color)
        var r1: CGFloat = 0; var g1: CGFloat = 0; var b1: CGFloat = 0; var a1: CGFloat = 0
        var r2: CGFloat = 0; var g2: CGFloat = 0; var b2: CGFloat = 0; var a2: CGFloat = 0
        uiColor1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        uiColor2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        return Color(red: (r1 + r2) / 2, green: (g1 + g2) / 2, blue: (b1 + b2) / 2)
    }
}
