import CoreGraphics

/// Spacing scale used for paddings, gaps, and inter-element distances.
/// Use these tokens instead of raw point values whenever you're describing
/// the empty space between things — frame sizes, corner radii, icon sizes
/// and other "shape" dimensions stay as raw values.
public enum DSSpacing {
    /// 2pt — tight intra-text gap (e.g., title to subtitle inside a row).
    public static let micro: CGFloat = 2
    /// 4pt — small element-internal gap.
    public static let tiny: CGFloat = 4
    /// 8pt — default small gap between siblings.
    public static let small: CGFloat = 8
    /// 12pt — comfortable spacing between related items.
    public static let medium: CGFloat = 12
    /// 16pt — default row padding.
    public static let large: CGFloat = 16
    /// 20pt — standard horizontal screen margin.
    public static let spacious: CGFloat = 20
    /// 24pt — section separation; comfortable vertical screen padding.
    public static let big: CGFloat = 24
    /// 32pt — block-level separation between unrelated content groups.
    public static let huge: CGFloat = 32
}
