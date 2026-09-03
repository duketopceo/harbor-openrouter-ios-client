import SwiftUI

struct ModelPickerView: View {
    let service: OpenRouterService
    @Binding var selectedModel: OpenRouter.Model?
    @State private var search = ""

    var filtered: [OpenRouter.Model] {
        if search.isEmpty { return service.models }
        return service.models.filter {
            ($0.name ?? $0.id).localizedCaseInsensitiveContains(search) ||
            $0.id.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                HarborDesign.Color.canvas.ignoresSafeArea()
                List(filtered) { model in
                    Button { selectedModel = model } label: {
                        ModelRow(model: model, isSelected: selectedModel?.id == model.id)
                    }
                    .listRowBackground(HarborDesign.Color.surface)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Models")
            .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
            .task { await service.fetchModels() }
            .refreshable { await service.fetchModels() }
        }
    }
}
