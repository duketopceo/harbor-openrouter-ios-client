import SwiftUI

struct ContentView: View {
    @Binding var apiKey: String
    let service: OpenRouterService
    @State private var selectedModel: OpenRouter.Model?
    @State private var tab = 0

    init(apiKey: Binding<String>) {
        _apiKey = apiKey
        service = OpenRouterService(apiKey: apiKey.wrappedValue)
    }

    var body: some View {
        TabView(selection: $tab) {
            ChatView(service: service, selectedModel: $selectedModel)
                .tabItem { Label("Chat", systemImage: "message.fill") }
                .tag(0)
            ModelPickerView(service: service, selectedModel: $selectedModel)
                .tabItem { Label("Models", systemImage: "cpu.fill") }
                .tag(1)
            CreditsView(service: service)
                .tabItem { Label("Credits", systemImage: "creditcard.fill") }
                .tag(2)
        }
        .tint(HarborDesign.Color.text)
        .preferredColorScheme(.dark)
    }
}
