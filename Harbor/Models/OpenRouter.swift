import Foundation

enum OpenRouter {
    struct Model: Identifiable, Codable, Hashable {
        let id: String
        let name: String?
        let description: String?
        let pricing: Pricing?
        let context_length: Int?
        let top_provider: TopProvider?
    }

    struct Pricing: Codable, Hashable {
        let prompt: String
        let completion: String
        let image: String?
        let request: String?
    }

    struct TopProvider: Codable, Hashable {
        let context_length: Int?
        let max_completion_tokens: Int?
        let is_moderated: Bool?
    }

    struct Message: Codable, Hashable {
        let role: String
        let content: String
    }

    struct ChatRequest: Codable {
        let model: String
        let messages: [Message]
        let stream: Bool
    }

    struct ChatChunk: Codable {
        let choices: [Choice]
    }

    struct Choice: Codable {
        let delta: Delta?
    }

    struct Delta: Codable {
        let content: String?
    }

    struct CreditResponse: Codable {
        let total_credits: Double
        let total_usage: Double
    }
}
