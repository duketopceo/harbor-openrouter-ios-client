import SwiftUI

struct ChatView: View {
    let service: OpenRouterService
    @Binding var selectedModel: OpenRouter.Model?
    @State private var input = ""
    @State private var messages: [OpenRouter.Message] = []
    @State private var streaming = false
    @State private var currentResponse = ""

    var body: some View {
        VStack(spacing: 0) {
            if let model = selectedModel {
                ScrollView {
                    ScrollViewReader { proxy in
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(messages.indices, id: \.self) { index in
                                MessageBubble(message: messages[index])
                            }
                            if !currentResponse.isEmpty {
                                MessageBubble(message: OpenRouter.Message(role: "assistant", content: currentResponse), isStreaming: true)
                                    .id("streaming")
                            }
                        }
                        .padding()
                        .onChange(of: currentResponse) { _ in
                            withAnimation { proxy.scrollTo("streaming", anchor: .bottom) }
                        }
                    }
                }
                .background(HarborDesign.Color.canvas)

                HStack(spacing: 8) {
                    TextField("Message \(model.name ?? model.id)", text: $input, axis: .vertical)
                        .font(HarborDesign.Typography.body)
                        .foregroundStyle(HarborDesign.Color.text)
                        .padding(12)
                        .background(HarborDesign.Color.surface)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(HarborDesign.Color.borderStrong, lineWidth: 1))

                    Button(action: send) {
                        Image(systemName: "arrow.up")
                            .font(HarborDesign.Typography.body)
                            .foregroundStyle(HarborDesign.Color.onBrand)
                            .frame(width: 40, height: 40)
                            .background(HarborDesign.Color.text)
                            .clipShape(Circle())
                    }
                    .disabled(input.isEmpty || streaming)
                }
                .padding(12)
                .background(HarborDesign.Color.surface)
                .overlay(Rectangle().frame(height: 1).foregroundStyle(HarborDesign.Color.border), alignment: .top)
            } else {
                VStack(spacing: 12) {
                    HarborMark()
                        .stroke(HarborDesign.Color.faint, lineWidth: 2)
                        .frame(width: 48, height: 48)
                    Text("Select a model in the Models tab")
                        .font(HarborDesign.Typography.caption)
                        .foregroundStyle(HarborDesign.Color.muted)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(HarborDesign.Color.canvas.ignoresSafeArea())
            }
        }
        .background(HarborDesign.Color.canvas.ignoresSafeArea())
        .navigationTitle(selectedModel?.name ?? "Harbor")
    }

    private func send() {
        guard let model = selectedModel, !input.isEmpty else { return }
        let userMessage = OpenRouter.Message(role: "user", content: input)
        messages.append(userMessage)
        let history = messages
        input = ""
        streaming = true
        currentResponse = ""
        Task {
            let stream = service.streamChat(model: model.id, messages: history)
            do {
                for try await text in stream {
                    currentResponse += text
                }
                messages.append(OpenRouter.Message(role: "assistant", content: currentResponse))
            } catch {
                messages.append(OpenRouter.Message(role: "assistant", content: "Error: \(error.localizedDescription)"))
            }
            currentResponse = ""
            streaming = false
        }
    }
}
