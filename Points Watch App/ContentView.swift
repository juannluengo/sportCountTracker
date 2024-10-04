import SwiftUI

// Enum to represent different screens in the navigation stack
enum Screen: Hashable {
    case matchSetup(sport: String)
    case pointsView(
        sport: String,
        matchType: MatchSetupView.MatchType,
        avatars: [String],
        isSetOption: Bool?,
        customSetPoints: Int?
    )
}

struct ContentView: View {
    @State private var path = [Screen]()
    
    // List of sports to display
    @State private var sports = ["Tennis", "Badminton", "Ping Pong", "Squash", "Padel", "Football", "Custom"]
    @State private var selectedSports: Set<String> = ["Tennis", "Badminton", "Ping Pong", "Squash", "Padel", "Football", "Custom"]
    
    // Mapping each sport to its corresponding color
    let colorMapping: [String: Color] = [
        "Tennis": .green,
        "Badminton": .blue,
        "Ping Pong": .orange,
        "Squash": .yellow,
        "Padel": .purple,
        "Football": .white,
        "Custom": .pink
    ]

    var body: some View {
        NavigationStack(path: $path) {
            // List content
            List {
                // Title text
                Text("SELECT SPORT")
                    .font(.headline)
                    .padding()
                    .listRowBackground(Color.clear) // Remove default list row background
                
                // Display the list of sports, filtered by the selected sports
                ForEach(sports.filter { selectedSports.contains($0) }, id: \.self) { sport in
                    let color = colorMapping[sport] ?? .gray  // Default to gray if no color is found

                    // Button to navigate to match setup view
                    Button(action: {
                        path.append(.matchSetup(sport: sport))
                    }) {
                        HStack {
                            // Sport icon
                            Image(systemName: icon(for: sport))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(color)
                                .padding(.leading, 20)

                            // Sport name
                            Text(sport)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(color)
                                .padding(.leading, 10)
                        }
                        .padding(.vertical, 35)
                    }
                    .frame(maxWidth: .infinity) // Ensure full width
                    .background(color.opacity(0.2))
                    .cornerRadius(20) // Apply rounded corners
                    .listRowInsets(EdgeInsets()) // Remove default list row padding
                    .listRowBackground(Color.clear) // Use clear background to keep custom styling
                }

                // Navigation link to HistoryView
                NavigationLink(destination: HistoryView()) {
                    HStack {
                        // History icon
                        Image(systemName: "clock.arrow.circlepath")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.green) // Matching color scheme
                            .padding(.leading, 20)

                        // History text
                        Text("History")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.green)
                            .padding(.leading, 10)
                    }
                    .padding(.vertical, 35)
                }
                .frame(maxWidth: .infinity) // Ensure full width
                .background(Color.green.opacity(0.2))
                .cornerRadius(20) // Apply rounded corners
                .listRowInsets(EdgeInsets()) // Remove default list row padding
                .listRowBackground(Color.clear) // Use clear background to keep custom styling

                // Navigation link to SettingsView
                NavigationLink(destination: SettingsView(sports: $sports, selectedSports: $selectedSports)) {
                    HStack {
                        // Settings icon
                        Image(systemName: "gear")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray) // Matching color scheme
                            .padding(.leading, 25)

                        // Settings text
                        Text("Settings")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                    }
                    .padding(.vertical, 35)
                }
                .frame(maxWidth: .infinity) // Ensure full width
                .background(Color.gray.opacity(0.2))
                .cornerRadius(20) // Apply rounded corners
                .listRowInsets(EdgeInsets()) // Remove default list row padding
                .listRowBackground(Color.clear) // Use clear background to keep custom styling

                // Add subtle extra spacing to scroll the Settings button to the middle
                Spacer()
                    .frame(height: 50) // Reduced spacing
                    .listRowBackground(Color.clear) // Use clear background to keep custom styling
            }
            .listStyle(CarouselListStyle()) // Apply carousel style
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .matchSetup(let sport):
                    MatchSetupView(sport: sport, path: $path)
                case .pointsView(let sport, let matchType, let avatars, let isSetOption, let customSetPoints):
                    PointsView(
                        sport: sport,
                        matchType: matchType,
                        avatars: avatars,
                        isSetOption: isSetOption,
                        customSetPoints: customSetPoints,
                        path: $path
                    )
                }
            }
            .navigationBarHidden(true) // Hide the navigation bar
        }
    }
    
    // Function to get the icon name for each sport
    func icon(for sport: String) -> String {
        switch sport {
        case "Tennis":
            return "figure.tennis"
        case "Badminton":
            return "figure.badminton"
        case "Ping Pong":
            return "figure.table.tennis"
        case "Squash":
            return "figure.squash"
        case "Padel":
            return "tennisball.fill"
        case "Football":
            return "soccerball"
        case "Custom":
            return "person.3.sequence"
        default:
            return "questionmark.circle"
        }
    }
}

// Preview provider for SwiftUI previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
