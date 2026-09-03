import SwiftUI

struct CreditsView: View {
    let service: OpenRouterService

    var body: some View {
        ZStack {
            HarborDesign.Color.canvas.ignoresSafeArea()
            VStack(spacing: 16) {
                if let credits = service.credits {
                    VStack(spacing: 8) {
                        Text(String(format: "$%.2f", max(0, credits.total_credits - credits.total_usage)))
                            .font(.system(size: 64, weight: .semibold, design: .default))
                            .foregroundStyle(HarborDesign.Color.text)
                        Text("remaining")
                            .font(HarborDesign.Typography.caption)
                            .foregroundStyle(HarborDesign.Color.muted)
                    }
                    HStack(spacing: 32) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(format: "$%.2f", credits.total_credits))
                                .font(HarborDesign.Typography.title)
                                .foregroundStyle(HarborDesign.Color.text)
                            Text("total")
                                .font(HarborDesign.Typography.caption)
                                .foregroundStyle(HarborDesign.Color.faint)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(format: "$%.2f", credits.total_usage))
                                .font(HarborDesign.Typography.title)
                                .foregroundStyle(HarborDesign.Color.text)
                            Text("used")
                                .font(HarborDesign.Typography.caption)
                                .foregroundStyle(HarborDesign.Color.faint)
                        }
                    }
                } else {
                    ProgressView()
                        .tint(HarborDesign.Color.text)
                        .task { await service.fetchCredits() }
                }
            }
        }
    }
}
