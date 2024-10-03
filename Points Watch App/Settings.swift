// Settings.swift

import Foundation
import Combine

class Settings: ObservableObject {
    @Published var sports: [String] {
        didSet {
            saveSettings()
        }
    }
    @Published var selectedSports: Set<String> {
        didSet {
            saveSettings()
        }
    }

    init() {
        sports = ["Tennis", "Badminton", "Ping Pong", "Squash", "Padel", "Football", "Custom"]
        selectedSports = ["Tennis", "Badminton", "Ping Pong", "Squash", "Padel", "Football", "Custom"]
        loadSettings()
    }

    func saveSettings() {
        let encoder = JSONEncoder()
        if let sportsData = try? encoder.encode(sports) {
            UserDefaults.standard.set(sportsData, forKey: "Sports")
        }
        if let selectedSportsData = try? encoder.encode(Array(selectedSports)) {
            UserDefaults.standard.set(selectedSportsData, forKey: "SelectedSports")
        }
    }

    func loadSettings() {
        let decoder = JSONDecoder()
        if let sportsData = UserDefaults.standard.data(forKey: "Sports"),
           let decodedSports = try? decoder.decode([String].self, from: sportsData) {
            sports = decodedSports
        }
        if let selectedSportsData = UserDefaults.standard.data(forKey: "SelectedSports"),
           let decodedSelectedSports = try? decoder.decode([String].self, from: selectedSportsData) {
            selectedSports = Set(decodedSelectedSports)
        }
    }
}
