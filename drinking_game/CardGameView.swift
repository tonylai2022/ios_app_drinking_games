import SwiftUI

struct CardGameView: View {
    @State private var drawnCards = ["back", "back", "back"]
    @State private var tapCount = 0
    @State private var drawnIndices: Set<Int> = []

    var body: some View {
        VStack {
            Spacer()
            HStack {
                ForEach(drawnCards.indices, id: \.self) { index in
                    Image(drawnCards[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 350)
                        .padding()
                }
            }
            Spacer()
        }
        .rotationEffect(Angle(degrees: 90)) // Rotate the entire view by 90 degrees
        .padding()
        .background(Color.green) // Add green background
        .onTapGesture {
            tapCount += 1
            switch tapCount {
            case 1:
                replaceLeftCard()
            case 2:
                replaceRightCard()
            case 3:
                replaceMiddleCard()
            case 4:
                resetAllCards()
            default:
                break
            }
        }
    }

    func replaceLeftCard() {
        if let firstBackIndex = drawnCards.firstIndex(of: "back") {
            let drawnCardIndex = getRandomCardIndex()
            drawnCards[firstBackIndex] = "card\(drawnCardIndex)"
            drawnIndices.insert(drawnCardIndex)
        }
    }

    func replaceRightCard() {
        if let lastBackIndex = drawnCards.lastIndex(of: "back") {
            let drawnCardIndex = getRandomCardIndex()
            drawnCards[lastBackIndex] = "card\(drawnCardIndex)"
            drawnIndices.insert(drawnCardIndex)
        }
    }

    func replaceMiddleCard() {
        let middleIndex = drawnCards.count / 2
        var drawnCardIndex = getRandomCardIndex()
        // Ensure the middle card drawn is not a repetition
        while drawnIndices.contains(drawnCardIndex) {
            drawnCardIndex = getRandomCardIndex()
        }
        drawnCards[middleIndex] = "card\(drawnCardIndex)"
        drawnIndices.insert(drawnCardIndex)
    }

    func getRandomCardIndex() -> Int {
        var randomIndex = Int.random(in: 1...52)
        // Ensure the card drawn is not a repetition
        while drawnIndices.contains(randomIndex) {
            randomIndex = Int.random(in: 1...52)
        }
        return randomIndex
    }

    func resetAllCards() {
        drawnCards = ["back", "back", "back"]
        tapCount = 0
        drawnIndices = []
    }
}

struct CardGameView_Previews: PreviewProvider {
    static var previews: some View {
        CardGameView()
    }
}
