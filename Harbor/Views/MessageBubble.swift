import SwiftUI

struct MessageBubble: View {
    let message: OpenRouter.Message
    var isStreaming = false

    var body: some View {
        HStack {
            if message.role == "user" { Spacer() }
            Text(message.content)
                .font(HarborDesign.Typography.body)
                .foregroundStyle(message.role == "user" ? HarborDesign.Color.text : HarborDesign.Color.body)
                .padding(12)
                .background(message.role == "user" ? HarborDesign.Color.surfaceElevated : HarborDesign.Color.surface)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(HarborDesign.Color.border, lineWidth: 1))
                .opacity(isStreaming ? 0.8 : 1)
            if message.role != "user" { Spacer() }
        }
    }
}
