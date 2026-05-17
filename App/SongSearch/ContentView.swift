import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "music.note")
                .imageScale(.large)
                .font(.system(size: 64))
                .foregroundStyle(.tint)
            Text("Song Search")
                .font(.title)
                .bold()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
