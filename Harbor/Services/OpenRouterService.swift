import Foundation
import Observation

@Observable
final class OpenRouterService {
    private let baseURL = URL(string: "https://openrouter.ai/api/v1")!
    private(set) var apiKey: String

    var models: [OpenRouter.Model] = []
    var credits: OpenRouter.CreditResponse?
    var error: String?
    var isLoading = false

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    private func makeRequest(path: String, method: String = "GET", body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("https://github.com/duketopceo/harbor", forHTTPHeaderField: "HTTP-Referer")
        request.setValue("Harbor", forHTTPHeaderField: "X-Title")
        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.httpBody = body
        return request
    }

    func fetchModels() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let (data, _) = try await URLSession.shared.data(for: makeRequest(path: "models"))
            let list = try JSONDecoder().decode(ModelList.self, from: data)
            models = list.data
        } catch {
            self.error = error.localizedDescription
        }
    }

    private struct ModelList: Codable {
        let data: [OpenRouter.Model]
    }

    func fetchCredits() async {
        do {
            let (data, _) = try await URLSession.shared.data(for: makeRequest(path: "credits"))
            credits = try JSONDecoder().decode(OpenRouter.CreditResponse.self, from: data)
        } catch {
            self.error = error.localizedDescription
        }
    }

    func streamChat(model: String, messages: [OpenRouter.Message]) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task {
                let body = OpenRouter.ChatRequest(model: model, messages: messages, stream: true)
                guard let encoded = try? JSONEncoder().encode(body) else {
                    continuation.finish(throwing: URLError(.badURL))
                    return
                }
                var request = makeRequest(path: "chat/completions", method: "POST", body: encoded)
                request.setValue("text/event-stream", forHTTPHeaderField: "Accept")

                do {
                    let (bytes, _) = try await URLSession.shared.bytes(for: request)
                    for try await line in bytes.lines {
                        if line.isEmpty || line == "[DONE]" { continue }
                        guard line.hasPrefix("data: ") else { continue }
                        let payload = String(line.dropFirst(6))
                        guard let data = payload.data(using: .utf8),
                              let chunk = try? JSONDecoder().decode(OpenRouter.ChatChunk.self, from: data),
                              let text = chunk.choices.first?.delta?.content else { continue }
                        continuation.yield(text)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
