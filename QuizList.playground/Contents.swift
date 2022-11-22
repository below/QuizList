import Combine
import SwiftUI
import PlaygroundSupport

struct ContentView: View {

    var body: some View {
        HStack {
            Button("Lorem ipsum dolor sit amet, consectetur adipiscing eli") {
            }
            .lineLimit(nil)
        }
        .frame(width: 200)
    }
}

PlaygroundPage.current.setLiveView(ContentView())
