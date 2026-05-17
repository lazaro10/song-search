import SwiftUI

public struct DSSectionHeader: View {
    @Environment(\.dsPalette) private var palette

    public let title: String
    public let actionTitle: String?
    public let action: (() -> Void)?

    public init(title: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.dsSectionTitle)
                .foregroundStyle(palette.text)
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.dsCaption)
                    .tint(.accentColor)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 6)
        .padding(.bottom, 10)
    }
}
