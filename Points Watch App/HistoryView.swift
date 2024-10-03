// Import the SwiftUI framework
import SwiftUI

// Define the HistoryView to display match history
struct HistoryView: View {
    // Access the MatchHistory environment object
    @EnvironmentObject var history: MatchHistory

    var body: some View {
        ScrollView {
            VStack {
                if history.matches.isEmpty {
                    Spacer() // Push content to the center
                    // Display message if no matches recorded
                    Text("No matches recorded yet")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center) // Center the text horizontally
                    Spacer() // Push content to the center
                } else {
                    // Group matches by date
                    let groupedMatches = Dictionary(grouping: history.matches, by: { formattedDate(from: $0.date) })

                    // Loop through each date group
                    ForEach(groupedMatches.keys.sorted(), id: \.self) { date in
                        VStack(alignment: .center) { // Center date groups
                            // Display date
                            Text(date)
                                .font(.headline)
                                .padding(.top, 10)
                                .frame(maxWidth: .infinity, alignment: .center) // Center the date text
                            
                            Divider() // Line below the date
                            
                            // Loop through matches on that date
                            ForEach(groupedMatches[date] ?? []) { match in
                                VStack {
                                    // Display the sport name
                                    Text(match.sport)
                                        .font(.subheadline)
                                        .fontWeight(.bold)

                                    HStack {
                                        // Check match type and display avatars and points accordingly
                                        if match.matchType == .oneVsOne {
                                            // Display avatars for 1 vs 1
                                            Image(systemName: match.avatars[0])
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                            
                                            Text("\(match.pointsP1) - \(match.pointsP2)")
                                                .padding(.horizontal, 5)
                                            
                                            Image(systemName: match.avatars[1])
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                        } else {
                                            // Display avatars for 2 vs 2
                                            VStack(spacing: 5) {
                                                Image(systemName: match.avatars[0])
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 20, height: 20)
                                                Image(systemName: match.avatars[1])
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 20, height: 20)
                                            }
                                            
                                            Text("\(match.pointsP1) - \(match.pointsP2)")
                                                .padding(.horizontal, 5)
                                            
                                            VStack(spacing: 5) {
                                                Image(systemName: match.avatars[2])
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 20, height: 20)
                                                Image(systemName: match.avatars[3])
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 20, height: 20)
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center) // Center the HStack
                                }
                                .padding(.leading, 10) // Indent for match details
                            }
                        }
                        .padding(.bottom, 10) // Space between date sections
                    }

                    Spacer() // Add some space before the clear button

                    // Clear history button, only visible when there are matches
                    Button(action: history.clearHistory) {
                        Text("Clear")
                            .font(.callout)
                            .padding(8)
                            .background(Color.red.opacity(0.2))
                            .foregroundColor(.red)
                            .cornerRadius(8)
                    }
                    .frame(width: 90, height: 30)
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 20) // Add some padding at the bottom for visual space
                }
            }
            .frame(maxWidth: .infinity, alignment: .center) // Center the VStack content
        }
    }

    // Helper function to format the date in "dd.MM.yyyy" format
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}
