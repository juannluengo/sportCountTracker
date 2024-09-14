import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var history: MatchHistory

    var body: some View {
        VStack {
            if history.matches.isEmpty {
                Text("No matches recorded yet.")
                    .padding()
            } else {
                ScrollView {
                    let groupedMatches = Dictionary(grouping: history.matches, by: { formattedDate(from: $0.date) })

                    ForEach(groupedMatches.keys.sorted(), id: \.self) { date in
                        VStack(alignment: .leading) {
                            Text(date)
                                .font(.headline)
                                .padding(.top, 10)
                            
                            Divider() // Line below the date
                            
                            ForEach(groupedMatches[date] ?? []) { match in
                                Text("\(match.sport) P1: \(match.pointsP1) P2: \(match.pointsP2)")
                                    .padding(.leading, 10) // Indent for match details
                            }
                        }
                        .padding(.bottom, 10) // Space between date sections
                    }
                }
            }

            Spacer()

            // Smaller delete button
            Button(action: history.clearHistory) {
                Text("Clear")
                    .font(.footnote)
                    .padding(8)
                    .background(Color.red.opacity(0.2))
                    .foregroundColor(.red)
                    .cornerRadius(8)
            }
            .frame(width: 90, height: 30)
        }
    }

    // Helper function to format the date in "dd.MM.yyyy" format
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}
