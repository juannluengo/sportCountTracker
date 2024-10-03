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
                    emptyHistoryView() // Display view when no matches are recorded
                } else {
                    matchHistoryView() // Display the list of matches
                    clearButton()      // Clear history button
                }
            }
            .frame(maxWidth: .infinity, alignment: .center) // Center the VStack content
        }
    }

    // MARK: - UI Components

    // View for when there are no matches recorded
    func emptyHistoryView() -> some View {
        VStack {
            Spacer() // Push content to the center vertically
            Text("No matches recorded yet")
                .padding()
                .frame(maxWidth: .infinity, alignment: .center) // Center the text horizontally
            Spacer() // Push content to the center vertically
        }
    }

    // View for displaying the list of matches grouped by date
    func matchHistoryView() -> some View {
        let groupedMatches = Dictionary(grouping: history.matches, by: { formattedDate(from: $0.date) })

        return VStack {
            // Loop through each date group
            ForEach(groupedMatches.keys.sorted(), id: \.self) { date in
                dateSectionView(date: date, matches: groupedMatches[date] ?? [])
            }

            Spacer() // Add some space before the clear button
        }
    }

    // View for displaying a section for each date
    func dateSectionView(date: String, matches: [Match]) -> some View {
        VStack(alignment: .center) { // Center date groups
            Text(date)
                .font(.headline)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .center) // Center the date text
            
            Divider() // Line below the date

            // Loop through matches on that date
            ForEach(matches) { match in
                matchDetailView(match: match)
            }
        }
        .padding(.bottom, 10) // Space between date sections
    }

    // View for displaying details of each match
    func matchDetailView(match: Match) -> some View {
        VStack {
            // Display the sport name
            Text(match.sport)
                .font(.subheadline)
                .fontWeight(.bold)
            
            HStack {
                if match.matchType == .oneVsOne {
                    oneVsOneView(match: match)
                } else {
                    twoVsTwoView(match: match)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center) // Center the HStack
        }
        .padding(.leading, 10) // Indent for match details
    }

    // View for displaying avatars and scores for a 1 vs 1 match
    func oneVsOneView(match: Match) -> some View {
        HStack {
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
        }
    }

    // View for displaying avatars and scores for a 2 vs 2 match
    func twoVsTwoView(match: Match) -> some View {
        HStack {
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

    // Clear history button
    func clearButton() -> some View {
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

    // MARK: - Helper Functions

    // Helper function to format the date in "dd.MM.yyyy" format
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}
