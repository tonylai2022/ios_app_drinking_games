import SwiftUI

struct RingOfFireView: View {
    let initialRemainingCards: [String] = {
        var cards = [String]()
        let ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
        let suits = ["♠️", "♣️", "♥️", "♦️"]
        for rank in ranks {
            for suit in suits {
                cards.append("\(rank)\(suit)")
            }
        }
        return cards
    }()
    
    let cards = [
        "2": "You - Pick someone to drink.",
        "3": "Me - You drink.",
        "4": "Girls - All females drink.",
        "5": "Thumbmaster - Put your thumb on the table. Last person to put their thumb on the table drinks.",
        "6": "Guys - All males drink.",
        "7": "Heaven - Point to the sky. Last person to point to the sky drinks.",
        "8": "Mate - Pick a mate who drinks whenever you drink.",
        "9": "Rhyme - Say a word, and everyone rhymes with that word until someone messes up.",
        "10": "Categories - Pick a category, and everyone names something from it until someone messes up.",
        "J": "Make a Rule - Create a new rule.",
        "Q": "Question Master - Become the Question Master. If someone answers your question, they drink.",
        "K": "King - Pour some of your drink into the cup in the middle. Last person to draw this drinks the middle cup.",
        "A": "Waterfall - Start drinking, and everyone follows until the person to their right stops."
    ]
    
    @State private var remainingCards: [String]
    @State private var card: String?
    @State private var action: String?
    
    init() {
        _remainingCards = State(initialValue: initialRemainingCards)
    }
    
    var body: some View {
        VStack {
            Text("Ring of Fire")
                .font(.largeTitle)
                .padding()
            
            if let card = card, let action = action {
                Text("Card: \(card)")
                    .font(.title)
                    .padding()
                
                Text("Action: \(action)")
                    .font(.title2)
                    .padding()
                    .multilineTextAlignment(.center)
            } else {
                Text("Draw a card to start the game.")
                    .font(.title)
                    .padding()
            }
            
            Spacer()
            
            Text("Remaining Cards: \(remainingCards.count)")
                .padding()
            
            Button("Draw Card") {
                drawCard()
            }
            .font(.title)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(remainingCards.isEmpty)

            
            Button("Reset Game") {
                resetGame()
            }
            .font(.title)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .padding()
    }

    func drawCard() {
        guard let randomCard = remainingCards.randomElement() else {
            return
        }
        card = randomCard
        let cardRank = String(randomCard.dropLast())
        action = cards[cardRank] ?? "No action"
        remainingCards.removeAll { $0 == randomCard }
    }
    
    func resetGame() {
        remainingCards = initialRemainingCards
        card = nil
        action = nil
    }
}

struct RingOfFireView_Previews: PreviewProvider {
    static var previews: some View {
        RingOfFireView()
    }
}
