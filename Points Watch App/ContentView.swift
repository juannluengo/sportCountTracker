import SwiftUI

struct ContentView: View {
    var sports = ["Tennis", "Badminton", "Ping Pong", "Squash", "Padel", "PickleBall", "Basketball", "Soccer", "Volleyball", "Golf", "Cricket", "Racquetball", "Bowling", "Darts", "Hockey", "Rugby", "American Football", "Baseball", "Softball", "Handball", "Table Football", "Lacrosse", "Ultimate Frisbee", "Water Polo", "Field Hockey"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Select Sport")
                        .font(.headline)
                        .padding()

                    ForEach(sports, id: \.self) { sport in
                        NavigationLink(destination: PointsView(sport: sport)) {
                            Text(sport)
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 5)
                    }

                    NavigationLink(destination: HistoryView()) {
                        Text("History")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: SettingsView()) {
                        Text("Settings")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}
