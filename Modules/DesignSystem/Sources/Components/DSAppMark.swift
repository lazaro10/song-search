import SwiftUI

public struct DSAppMark: View {
    public let size: CGFloat
    public let color: Color

    public init(size: CGFloat = 96, color: Color = .accentColor) {
        self.size = size
        self.color = color
    }

    public var body: some View {
        ZStack {
            Image(.search)
                .font(.system(size: size, weight: .regular))
                .foregroundStyle(color)
            Image(.note)
                .font(.system(size: size * 0.42, weight: .bold))
                .foregroundStyle(color)
                .offset(x: -size * 0.08, y: -size * 0.06)
        }
        .frame(width: size, height: size)
    }
}
