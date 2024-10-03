import SwiftUI

struct SettingsView: View {
    // Binding variables for sports and selected sports
    @Binding var sports: [String]
    @Binding var selectedSports: Set<String>
    
    // State variable to control the display of the MenuView
    @State private var showMenuView = false

    var body: some View {
        VStack {
            // Menu view button
            menuViewButton()
            
            Spacer() // Pushes content to the top
        }
        .padding()
        .padding(.top, 10) // Add safe area padding at the top to avoid collapsing with the title
        .navigationTitle("Settings")
    }
    
    // MARK: - UI Components

    // Button for displaying the Menu View
    func menuViewButton() -> some View {
        HStack {
            Text("Menu View")
                .font(.system(size: 14))
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .onTapGesture {
            showMenuView = true
        }
        .sheet(isPresented: $showMenuView) {
            MenuView(sports: $sports, selectedSports: $selectedSports)
        }
    }
}

// Define the MenuView to manage the sports selection and reordering
struct MenuView: View {
    @Binding var sports: [String]
    @Binding var selectedSports: Set<String>
    
    // Determine if the screen size is small
    var isSmallScreen: Bool {
        WKInterfaceDevice.current().screenBounds.width < 170
    }

    var body: some View {
        ScrollView {
            VStack {
                // Sort and display sports, with selected ones at the top
                ForEach(sports.filter { selectedSports.contains($0) } + sports.filter { !selectedSports.contains($0) }, id: \.self) { sport in
                    if let index = sports.firstIndex(of: sport) {
                        reorderableRow(for: index, sport: sport)
                    }
                }
                Spacer() // Adds extra space at the bottom
                    .frame(height: 30)
            }
        }
        .padding()
        .edgesIgnoringSafeArea(.bottom) // Ignore bottom safe area to allow full scrolling
    }
    
    // MARK: - UI Components

    // Creates a row for each sport that can be reordered and toggled
    @ViewBuilder
    private func reorderableRow(for index: Int, sport: String) -> some View {
        HStack {
            // Button to move the sport up in the list
            moveUpButton(for: index)

            // Toggle for selecting or deselecting a sport
            sportToggle(for: sport)
        }
        .padding(.vertical, 15) // Adjust vertical padding
        .padding(.horizontal)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }

    // Button for moving an item up in the list
    private func moveUpButton(for index: Int) -> some View {
        Button(action: {
            moveItemUp(from: index)
        }) {
            Image(systemName: "arrow.up")
                .resizable()
                .frame(width: isSmallScreen ? 10 : 12, height: isSmallScreen ? 10 : 12) // Adjust arrow size based on screen size
                .foregroundColor(.blue)
        }
        .buttonStyle(.plain) // Remove default button styling
        .padding(.trailing, isSmallScreen ? 5 : 10)
    }

    // Toggle for selecting or deselecting a sport
    private func sportToggle(for sport: String) -> some View {
        Toggle(isOn: Binding(
            get: { selectedSports.contains(sport) },
            set: { isSelected in
                if isSelected {
                    selectedSports.insert(sport)
                } else {
                    selectedSports.remove(sport)
                }
            }
        )) {
            Text(sport)
                .font(.system(size: isSmallScreen ? 12 : 14)) // Adjust font size based on screen size
        }
    }

    // MARK: - Helper Functions

    // Function to move an item up in the list
    private func moveItemUp(from index: Int) {
        guard index > 0 else { return } // Prevent moving the first item up
        sports.swapAt(index, index - 1)
    }
}

// Preview provider for SwiftUI previews
struct SettingsView_Previews: PreviewProvider {
    @State static var sports = ["Tennis", "Badminton", "Ping Pong", "Squash", "Padel", "Scoreboard"]
    @State static var selectedSports: Set<String> = ["Tennis", "Badminton", "Ping Pong", "Squash", "Padel"]

    static var previews: some View {
        SettingsView(sports: $sports, selectedSports: $selectedSports)
    }
}
