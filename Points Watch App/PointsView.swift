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

    // Timer variables
    @State private var countdown: Int = 3
    @State private var matchTime: TimeInterval = 0
    @State private var isCountdownActive: Bool = true
    @State private var isMatchTimerActive: Bool = false
    @State private var matchTimer: Timer?
    @State private var countdownTimer: Timer?
    @State private var lapTimes: [TimeInterval] = []

    // For countdown animation
    @State private var countdownProgress: Double = 1.0

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

    // The score board layout
    var body: some View {
        if isCountdownActive {
            // Show the countdown timer with circular animation
            ZStack {
                Circle()
                    .trim(from: 0.0, to: countdownProgress)
                    .stroke(Color.blue, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 150, height: 150)
                    .animation(.linear(duration: 1), value: countdownProgress)

                Text("\(countdown)")
                    .font(.system(size: 80))
                    .onAppear {
                        startCountdownTimer()
                    }
            }
        } else {
            // Existing UI
            ScrollView {
                VStack(spacing: 10) {
                    // Clock at the top
                    Text("\(formattedTime(matchTime))")
                        .font(.footnote)
                        .padding(.leading, 10)
                        .padding(.top, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Top rectangle
                    Text("\(setsP1) : \(setsP2)")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(topColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding([.leading, .trailing])

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
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .background(p1Color)
                        .cornerRadius(10)
                        .gesture(
                            DragGesture(minimumDistance: 0)
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
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .background(p2Color)
                        .cornerRadius(10)
                        .gesture(
                            DragGesture(minimumDistance: 0)
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
                    .frame(height: 300)

                    // Additional clock functionalities
                    VStack(spacing: 10) {
                        Text("Match Time: \(formattedTime(matchTime))")
                            .font(.title2)
                            .padding()

                        HStack(spacing: 20) {
                            Button(action: {
                                if isMatchTimerActive {
                                    pauseMatchTimer()
                                } else {
                                    resumeMatchTimer()
                                }
                            }) {
                                Image(systemName: isMatchTimerActive ? "pause.fill" : "play.fill")
                                    .font(.title)
                            }

                            Button(action: {
                                resetMatchTimer()
                            }) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.title)
                            }

                            Button(action: {
                                lapTimes.append(matchTime)
                            }) {
                                Image(systemName: "flag")
                                    .font(.title)
                            }
                        }
                        .padding()

                        if !lapTimes.isEmpty {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Lap Times:")
                                    .font(.headline)
                                ForEach(Array(lapTimes.enumerated()), id: \.offset) { index, lap in
                                    Text("Lap \(index + 1): \(formattedTime(lap))")
                                }
                            }
                            .padding()
                        }
                    }

                    // Finish Button at the bottom
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
                    .padding(.bottom, 20)
                }
                .padding(.top, 10)
            }
            .onDisappear {
                countdownTimer?.invalidate()
                matchTimer?.invalidate()
            }
        }
    }

    // Haptic feedback
    private func provideHapticFeedback() {
        WKInterfaceDevice.current().play(.success)
    }

    // Animate button
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

    // Score display function
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
        saveCurrentState()
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
        saveCurrentState()
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
                    pointsP1 += 1
                } else if pointsP1 > pointsP2 {
                    winGame(player: 1)
                } else {
                    pointsP1 += 1
                }
            } else {
                pointsP1 += 1
            }
        } else if player == 2 {
            if pointsP2 == 3 && pointsP1 < 3 {
                winGame(player: 2)
            } else if pointsP2 >= 3 && pointsP1 >= 3 {
                if pointsP2 == pointsP1 {
                    pointsP2 += 1
                } else if pointsP2 > pointsP1 {
                    winGame(player: 2)
                } else {
                    pointsP2 += 1
                }
            } else {
                pointsP2 += 1
            }
        }
    }

    // Increment logic for Badminton, Squash, and Ping Pong
    func incrementBadmintonSquashPingPong(player: Int) {
        let maxThreshold = sport == "Badminton" ? 20 : 10
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
        actionHistory.removeAll()
        resetMatchTimer()
    }

    // Timer functions
    func startCountdownTimer() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if countdown > 1 {
                countdown -= 1
                countdownProgress -= 1 / 2.0
            } else {
                countdownTimer?.invalidate()
                isCountdownActive = false
                startMatchTimer()
            }
        }
    }

    func startMatchTimer() {
        isMatchTimerActive = true
        matchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            matchTime += 1
        }
    }

    func pauseMatchTimer() {
        isMatchTimerActive = false
        matchTimer?.invalidate()
    }

    func resumeMatchTimer() {
        isMatchTimerActive = true
        matchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            matchTime += 1
        }
    }

    func resetMatchTimer() {
        isMatchTimerActive = false
        matchTimer?.invalidate()
        matchTime = 0
        lapTimes.removeAll()
    }

    // Format time interval to display string
    func formattedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
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
