import SwiftUI

public enum DSAccent: String, Sendable, CaseIterable, Identifiable, Codable {
    case deepPurple
    case coral
    case forestTeal

    public var id: String { rawValue }

    public var label: String {
        switch self {
        case .deepPurple: "Deep Purple"
        case .coral: "Coral"
        case .forestTeal: "Forest Teal"
        }
    }

    public var hex: String {
        switch self {
        case .deepPurple: "#6E45D6"
        case .coral: "#F0795F"
        case .forestTeal: "#1F9D77"
        }
    }

    public var color: Color {
        Color(hex: hex)
    }
}
