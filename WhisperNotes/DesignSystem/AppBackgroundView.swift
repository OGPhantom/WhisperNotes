import SwiftUI

struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            AppTheme.backgroundGradient
                .ignoresSafeArea()

            AppTheme.topGlow
                .ignoresSafeArea()

            AppTheme.bottomGlow
                .ignoresSafeArea()
        }
    }
}
