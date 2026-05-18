import SwiftUI

public struct DSEmptyState: View {
    @Environment(\.dsPalette) private var palette

    public let systemImage: String
    public let title: String
    public let message: String
    public let actionTitle: String?
    public let action: (() -> Void)?

    public init(
        systemImage: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.systemImage = systemImage
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
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
            .accessibilityHidden(true)
            Text(title)
                .font(.dsItemTitle)
                .foregroundStyle(palette.text)
                .accessibilityAddTraits(.isHeader)
            Text(message)
                .font(.dsCaption)
                .foregroundStyle(palette.textSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 240)

            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.dsBody)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .frame(minHeight: 40)
                        .background(Color.accentColor, in: Capsule())
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 40)
    }
}
