import SwiftUI

struct HarborMark: Shape {
    var lineWidth: CGFloat = 2

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - lineWidth / 2
        path.addArc(center: center, radius: radius, startAngle: .degrees(30), endAngle: .degrees(330), clockwise: false)
        return path.strokedPath(.init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
    }
}
