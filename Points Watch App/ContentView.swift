// ContentView.swift

// Import the SwiftUI framework
import SwiftUI

// Define the main content view
struct ContentView: View {
   // List of sports to display
    var sports = ["Tennis", "Badminton", "Ping Pong", "Squash", "Padel", "Scoreboard"]
   // Corresponding colors for each sport
    var colors: [Color] = [.blue, .red, .green, .orange, .purple, .brown]

   var body: some View {
       // Use a navigation view to allow navigation to other views
       NavigationView {
           // Scrollable content
           ScrollView {
               VStack {
                   // Title text
                   Text("SELECT SPORT")
                       .font(.headline)
                       .padding()

                   // Loop through sports and colors using ForEach
                   ForEach(Array(zip(sports, colors)), id: \.0) { sport, color in
                       // Navigation link to PointsView for each sport
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

                   // Navigation link to SettingsView (currently points to HistoryView)
                   NavigationLink(destination: HistoryView()) {
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
