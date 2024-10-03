// ContentView.swift

// Import the SwiftUI framework
import SwiftUI

// Define the main content view
struct ContentView: View {
    // List of sports to display
    @State private var sports = ["Tennis", "Badminton", "Ping Pong", "Squash", "Padel", "Football", "Scoreboard"]
    @State private var selectedSports: Set<String> = ["Tennis", "Badminton", "Ping Pong", "Squash", "Padel", "Scoreboard"]
    
    // Mapping each sport to its corresponding color
    let colorMapping: [String: Color] = [
        "Tennis": .green,
        "Badminton": .blue,
        "Ping Pong": .orange,
        "Squash": .yellow,
        "Padel": .purple,
        "Football": .white,
        "Scoreboard": .pink
    ]

    var body: some View {
        // Navigation view to enable navigation to other views
        NavigationView {
            // Scrollable content
            ScrollView {
                VStack {
                    // Title text
                    Text("SELECT SPORT")
                        .font(.headline)
                        .padding()

                    // Display the list of sports, filtered by the selected sports
                    ForEach(sports.filter { selectedSports.contains($0) }, id: \.self) { sport in
                        let color = colorMapping[sport] ?? .gray  // Default to gray if no color is found

                        // Navigation link to match setup view
                        NavigationLink(destination: MatchSetupView(sport: sport)) {
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
                            .padding(.vertical, 20)
                            .background(color.opacity(0.2))
                            .cornerRadius(20)
                        }
                        .buttonStyle(PlainButtonStyle())
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
                        .padding(.vertical, 20)
                        .background(Color.green.opacity(0.2)) // Matching background style
                        .cornerRadius(20)
                    }
                    .buttonStyle(PlainButtonStyle())

                    // Navigation link to SettingsView
                    NavigationLink(destination: SettingsView(sports: $sports, selectedSports: $selectedSports)) {
                        HStack {
                            // Settings icon
                            Image(systemName: "gear")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray) // Matching color scheme
                                .padding(.leading, 20)

                            // Settings text
                            Text("Settings")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                        }
                        .padding(.vertical, 20)
                        .background(Color.gray.opacity(0.2)) // Matching background style
                        .cornerRadius(20)
                    }
                    .buttonStyle(PlainButtonStyle())
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
            return "figure.tennis"
        case "Padel":
            return "figure.tennis"
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
