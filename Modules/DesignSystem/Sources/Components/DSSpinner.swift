import SwiftUI

public struct DSSpinner: View {
    @Environment(\.dsPalette) private var palette

    public let size: CGFloat

    @State private var isAnimating = false

    public init(size: CGFloat = 22) {
        self.size = size
    }

    public var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(palette.textSecondary, style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .frame(width: size, height: size)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(.linear(duration: 0.85).repeatForever(autoreverses: false), value: isAnimating)
            .onAppear { isAnimating = true }
    }
}
