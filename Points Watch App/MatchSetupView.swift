// MatchSetupView.swift

import SwiftUI

struct MatchSetupView: View {
    // The sport selected (passed from ContentView)
    var sport: String
    @Binding var path: [Screen]

    // State variables for match setup
    @State private var matchType: MatchType?
    @State private var currentStep: MatchSetupStep = .chooseMatchType
    @State private var selectedAvatars: [String] = []
    @State private var availableAvatars: [String] = ["person.circle", "dog.circle", "cat.circle", "fish.circle", "bird.circle", "hare.circle", "tortoise.circle", "ladybug.circle"]
    
    @State private var isSetOption: Bool?
    @State private var customSetPoints: Int = 10

    var isTeams: Bool {
        return sport == "Football"
    }

    // Enumeration for match types
    enum MatchType {
        case oneVsOne
        case twoVsTwo
    }

    // Enumeration for match setup steps
    enum MatchSetupStep: Equatable {
        case chooseSetOption
        case chooseSetPoints
        case chooseMatchType
        case chooseAvatar(playerNumber: Int)
        case readyToStart
    }

    var body: some View {
        VStack {
            switch currentStep {
            case .chooseSetOption:
                chooseSetOptionView()
            case .chooseSetPoints:
                chooseSetPointsView()
            case .chooseMatchType:
                chooseMatchTypeView()
            case .chooseAvatar(let playerNumber):
                chooseAvatarView(for: playerNumber)
            case .readyToStart:
                readyToStartView()
            }
        }
        .onAppear {
            if sport == "Custom" {
                currentStep = .chooseSetOption
            } else if isTeams && currentStep == .chooseMatchType {
                currentStep = .chooseAvatar(playerNumber: 1)
                matchType = .oneVsOne
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - UI Components

    // View for choosing between Set and No Set
    func chooseSetOptionView() -> some View {
        VStack {
            Text("Choose Type")
                .font(.headline)
                .padding()
            
            HStack(spacing: 10) {
                Button(action: {
                    isSetOption = true
                    currentStep = .chooseSetPoints
                }) {
                    Text("Set")
                        .font(.headline)
                        .padding()
                        .frame(width: 70, height: 70)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(25)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    isSetOption = false
                    currentStep = .chooseMatchType
                }) {
                    Text("No Set")
                        .font(.headline)
                        .padding()
                        .frame(width: 70, height: 70)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(25)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    // View for choosing the number of points per set
    func chooseSetPointsView() -> some View {
        VStack {
            Text("Points per Set")
                .font(.headline)
                .padding()
            
            HStack(spacing: 20) {
                Button(action: {
                    if customSetPoints > 2 {
                        customSetPoints -= 1
                    }
                }) {
                    Image(systemName: "minus.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(PlainButtonStyle())
                
                Text("\(customSetPoints)")
                    .font(.title)
                
                Button(action: {
                    customSetPoints += 1
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            
            Button(action: {
                currentStep = .chooseMatchType
            }) {
                Text("Next")
                    .font(.headline)
                    .padding()
                    .frame(width: 70, height: 40)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
        }
    }

    // View for choosing the match type (1 vs 1 or 2 vs 2)
    func chooseMatchTypeView() -> some View {
        VStack {
            Text("Match Type")
                .font(.headline)
                .padding()
            
            HStack(spacing: 10) {
                Button(action: {
                    matchType = .oneVsOne
                    currentStep = .chooseAvatar(playerNumber: 1)
                }) {
                    Text("1 vs 1")
                        .font(.headline)
                        .padding()
                        .frame(width: 70, height: 70)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(25)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    matchType = .twoVsTwo
                    currentStep = .chooseAvatar(playerNumber: 1)
                }) {
                    Text("2 vs 2")
                        .font(.headline)
                        .padding()
                        .frame(width: 70, height: 70)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(25)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
        }
    }

    // View for choosing avatars for each player
    func chooseAvatarView(for playerNumber: Int) -> some View {
        VStack {
            Text(isTeams ? "Choose Team \(playerNumber)" : "Choose Player \(playerNumber)")

                .font(.headline)
                .padding()
            
            let columns = [GridItem(.adaptive(minimum: 60))]
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(availableAvatars, id: \.self) { avatar in
                        Button(action: {
                            selectAvatar(avatar, for: playerNumber)
                        }) {
                            Image(systemName: avatar)
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
    }

    // View for displaying the ready-to-start match setup
    func readyToStartView() -> some View {
        VStack {
            if matchType == .oneVsOne {
                HStack(spacing: 10) {
                    Image(systemName: selectedAvatars[0])
                        .resizable()
                        .frame(width: 40, height: 40)
                    
                    Text("vs")
                        .font(.headline)
                        .padding()
                    
                    Image(systemName: selectedAvatars[1])
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .padding()
            } else if matchType == .twoVsTwo {
                HStack(spacing: 10) {
                    VStack {
                        Image(systemName: selectedAvatars[0])
                            .resizable()
                            .frame(width: 30, height: 30)
                        Image(systemName: selectedAvatars[1])
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    Text("vs")
                        .font(.headline)
                        .padding()
                    
                    VStack {
                        Image(systemName: selectedAvatars[2])
                            .resizable()
                            .frame(width: 30, height: 30)
                        Image(systemName: selectedAvatars[3])
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                .padding()
            }

            Button(action: {
                path.append(.pointsView(
                    sport: sport,
                    matchType: matchType!,
                    avatars: selectedAvatars,
                    isSetOption: isSetOption,
                    customSetPoints: customSetPoints
                ))
            }) {
                Text("START")
                    .font(.headline)
                    .foregroundColor(Color.red)
                    .padding()
                    .frame(height: 40)
                    .background(Color.red.opacity(0.4))
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
        }
    }

    // MARK: - Helper Functions

    // Selects an avatar and updates the setup flow
    func selectAvatar(_ avatar: String, for playerNumber: Int) {
        selectedAvatars.append(avatar)
        if let index = availableAvatars.firstIndex(of: avatar) {
            availableAvatars.remove(at: index)
        }
        if let matchType = matchType {
            let totalPlayers = isTeams ? 2 : (matchType == .oneVsOne ? 2 : 4)
            if selectedAvatars.count < totalPlayers {
                currentStep = .chooseAvatar(playerNumber: playerNumber + 1)
            } else {
                currentStep = .readyToStart
            }
        }
    }
}

// Preview provider for SwiftUI previews
struct MatchSetupView_Previews: PreviewProvider {
    @State static var path: [Screen] = []
    static var previews: some View {
        MatchSetupView(sport: "Tennis", path: $path)
    }
}
