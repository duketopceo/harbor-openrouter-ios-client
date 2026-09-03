import SwiftUI

struct ModelRow: View {
    let model: OpenRouter.Model
    let isSelected: Bool

    var status: Color {
        if isSelected { return HarborDesign.Color.info }
        if (model.context_length ?? 0) < 8192 { return HarborDesign.Color.warning }
        return HarborDesign.Color.success
    }

    private func price(_ value: String?) -> String {
        guard let value, let perToken = Double(value) else { return "—" }
        return String(format: "$%.2f / 1M", perToken * 1_000_000)
    }

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(status)
                .frame(width: 8, height: 8)
            VStack(alignment: .leading, spacing: 4) {
                Text(model.name ?? model.id)
                    .font(HarborDesign.Typography.title)
                    .foregroundStyle(HarborDesign.Color.text)
                Text(model.id)
                    .font(HarborDesign.Typography.mono)
                    .foregroundStyle(HarborDesign.Color.faint)
            }
            Spacer()
            if let pricing = model.pricing {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("in: \(price(pricing.prompt))")
                        .font(HarborDesign.Typography.mono)
                        .foregroundStyle(HarborDesign.Color.muted)
                    Text("out: \(price(pricing.completion))")
                        .font(HarborDesign.Typography.mono)
                        .foregroundStyle(HarborDesign.Color.faint)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(isSelected ? HarborDesign.Color.surfaceElevated : HarborDesign.Color.surface)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? HarborDesign.Color.borderStrong : HarborDesign.Color.border, lineWidth: 1)
        )
    }
}
