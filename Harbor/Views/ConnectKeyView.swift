import SwiftUI

struct ConnectKeyView: View {
    @Binding var apiKey: String
    @State private var input = ""
    @State private var error = ""

    var body: some View {
        ZStack {
            HarborDesign.Color.canvas.ignoresSafeArea()
            VStack(spacing: 24) {
                HarborMark()
                    .stroke(HarborDesign.Color.text, lineWidth: 2)
                    .frame(width: 64, height: 64)
                Text("Harbor")
                    .font(HarborDesign.Typography.display)
                    .foregroundStyle(HarborDesign.Color.text)
                Text("Unofficial OpenRouter client. BYOK.")
                    .font(HarborDesign.Typography.caption)
                    .foregroundStyle(HarborDesign.Color.muted)
                    .multilineTextAlignment(.center)
                VStack(alignment: .leading, spacing: 8) {
                    Text("OpenRouter API key")
                        .font(HarborDesign.Typography.caption)
                        .foregroundStyle(HarborDesign.Color.muted)
                    SecureField("sk-or-v1-...", text: $input)
                        .font(HarborDesign.Typography.body)
                        .foregroundStyle(HarborDesign.Color.text)
                        .padding(12)
                        .background(HarborDesign.Color.surface)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(HarborDesign.Color.borderStrong, lineWidth: 1))
                        .textContentType(.password)
                    if !error.isEmpty {
                        Text(error)
                            .font(HarborDesign.Typography.caption)
                            .foregroundStyle(HarborDesign.Color.danger)
                    }
                }
                Button(action: connect) {
                    HStack {
                        Spacer()
                        Text("Connect")
                            .font(HarborDesign.Typography.body)
                            .foregroundStyle(HarborDesign.Color.onBrand)
                        Spacer()
                    }
                    .padding(14)
                    .background(HarborDesign.Color.text)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(24)
        }
    }

    private func connect() {
        guard input.count > 20 else {
            error = "Paste a full API key"
            return
        }
        Keychain.apiKey = input
        apiKey = input
    }
}
