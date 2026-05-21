import SwiftUI
import ImageLoader
import Networking

public struct DSBlurredBackdrop: View {
    @Environment(\.dsPalette) private var palette
    @Environment(NetworkReachability.self) private var reachability

    private let url: URL?
    private let blurRadius: CGFloat
    private let saturation: Double
    private let opacity: Double
    private let height: CGFloat?

    @State private var image: Image?

    public init(
        url: URL?,
        blurRadius: CGFloat = 40,
        saturation: Double = 1.4,
        opacity: Double = 0.4,
        height: CGFloat? = nil
    ) {
        self.url = url
        self.blurRadius = blurRadius
        self.saturation = saturation
        self.opacity = opacity
        self.height = height
    }

    public var body: some View {
        GeometryReader { proxy in
            let resolvedHeight = height ?? proxy.size.height
            ZStack(alignment: .top) {
                palette.background

                if let image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: resolvedHeight)
                        .clipped()
                        .blur(radius: blurRadius)
                        .saturation(saturation)
                        .opacity(opacity)
                }
            }
            .frame(width: proxy.size.width, height: resolvedHeight)
            .clipped()
        }
        .task(id: taskID) {
            await loadImage()
        }
        .accessibilityHidden(true)
    }

    private var taskID: String {
        "\(url?.absoluteString ?? "")-\(reachability.retryToken)"
    }

    private func loadImage() async {
        guard let url else {
            image = nil
            return
        }
        image = await ImageLoader.load(from: url)
    }
}
