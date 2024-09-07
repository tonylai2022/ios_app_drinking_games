import SwiftUI

@main
struct drinking_gameApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
        }
    }
}

struct HomeView: View {
    var body: some View {
        List {
            NavigationLink(destination: DiceGameOneView()) {
                Text("Roll Dice Game")
            }
            NavigationLink(destination: CardGameView()) {
                Text("Penalty")
            }
            NavigationLink(destination: RingOfFireView()) {
                Text("Ring of fire")
            }
            // Add more game options as needed
        }
        .navigationTitle("Games")
    }
}
