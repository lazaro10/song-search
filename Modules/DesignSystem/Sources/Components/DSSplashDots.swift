import SwiftUI

public struct DSSplashDots: View {
    public let color: Color

    @State private var phase: Int = 0

    public init(color: Color = .white) {
        self.color = color
    }

    public var body: some View {
        HStack(spacing: DSSpacing.small) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)
                    .opacity(phase == index ? 1.0 : 0.35)
                    .scaleEffect(phase == index ? 1.0 : 0.65)
                    .animation(.easeInOut(duration: 0.4), value: phase)
            }
        }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(360))
                phase = (phase + 1) % 3
            }
        }
    }
}
