import SwiftUI
import DesignSystem
import Localization

struct SplashView: View {
    @Environment(\.dsAccent) private var accent
    let onComplete: () -> Void

    var body: some View {
        ZStack {
            accent.color
                .ignoresSafeArea()

            RadialGradient(
                colors: [Color.white.opacity(0.18), .clear],
                center: UnitPoint(x: 0.5, y: 0.25),
                startRadius: 0,
                endRadius: 360
            )
            .ignoresSafeArea()

            VStack(spacing: DSSpacing.big) {
                ZStack {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white.opacity(0.12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                        .frame(width: 124, height: 124)
                        .shadow(color: .black.opacity(0.18), radius: 25, y: 18)

                    DSAppMark(size: 86, color: .white)
                }

                VStack(spacing: DSSpacing.small) {
                    Text(L10n.Splash.appName)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)

                    Text(L10n.Splash.tagline)
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }

            VStack {
                Spacer()
                DSSplashDots(color: .white)
                    .padding(.bottom, 80)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(1.5))
            onComplete()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.A11y.splash)
    }
}
