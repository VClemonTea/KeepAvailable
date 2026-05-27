import SwiftUI

@main
struct KeepAvailableApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 400, height: 420)
        .windowResizability(.contentSize)
    }
}
