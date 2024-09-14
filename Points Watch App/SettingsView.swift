import Foundation

import SwiftUI

struct SettingsView: View {
    @AppStorage("longPressEnabled") private var longPressEnabled = true
    
    var body: some View {
        Form {
            Toggle("Enable Long Press", isOn: $longPressEnabled)
        }
        .navigationTitle("Settings")
    }
}
