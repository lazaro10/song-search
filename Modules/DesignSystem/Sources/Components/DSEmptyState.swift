import SwiftUI

public struct DSEmptyState: View {
    @Environment(\.dsPalette) private var palette

    public let systemImage: String
    public let title: String
    public let message: String

    public init(systemImage: String, title: String, message: String) {
        self.systemImage = systemImage
        self.title = title
        self.message = message
    }

    public var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(palette.surface)
                    .frame(width: 96, height: 96)
                Image(systemName: systemImage)
                    .font(.system(size: 40, weight: .regular))
                    .foregroundStyle(palette.textSecondary)
            }
            Text(title)
                .font(.dsItemTitle)
                .foregroundStyle(palette.text)
            Text(message)
                .font(.dsCaption)
                .foregroundStyle(palette.textSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 240)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 40)
    }
}
