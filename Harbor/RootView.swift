import SwiftUI

struct RootView: View {
    @State private var apiKey = ""

    var body: some View {
        Group {
            if apiKey.isEmpty {
                ConnectKeyView(apiKey: $apiKey)
            } else {
                ContentView(apiKey: $apiKey)
            }
        }
        .onAppear { apiKey = Keychain.apiKey ?? "" }
    }
}
