import SwiftUI
import CoreMotion

struct DiceGameOneView: View {
    @State private var numberOfDice = 1 {
        didSet {
            updateDiceArrays()
        }
    }
    @State private var diceResults = [Int]()
    @State private var isRolling = false
    @State private var dicePositions = [CGPoint]()
    @State private var draggingIndex: Int? = nil

    // Motion manager to handle accelerometer data
    let motionManager = CMMotionManager()

    var body: some View {
        VStack {
            // Stepper and buttons area
            HStack {
                Button(action: {
                    if numberOfDice > 1 {
                        numberOfDice -= 1
                    }
                }) {
                    Image(systemName: "minus")
                }
                .padding(.vertical, 10)
                .padding(.leading, 20)
                Spacer()
                Text("Number of dice: \(numberOfDice)")
                    .padding(.horizontal, 20)
                Spacer()
                Button(action: {
                    if numberOfDice < 5 {
                        numberOfDice += 1
                    }
                }) {
                    Image(systemName: "plus")
                }
                .padding(.vertical, 10)
                .padding(.trailing, 20)
            }
            .padding(3.0)
            .background(Color.white)

            // Dice results area
            GeometryReader { geometry in
                ZStack {
                    ForEach(0..<numberOfDice, id: \.self) { index in
                        if index < diceResults.count && index < dicePositions.count {
                            Image("\(diceResults[index])")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .position(dicePositions[index])
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            draggingIndex = index
                                            dicePositions[index] = value.location
                                        }
                                        .onEnded { _ in
                                            draggingIndex = nil
                                        }
                                )
                        }
                    }
                }
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .onAppear {
                    updateDicePositions(in: geometry.size)
                }
            }
            .padding(10)
            .background(Color.gray)

            Text("Tap or shake to roll")
                .padding()

        }
        .background(Color.gray)
        .edgesIgnoringSafeArea(.all)
        .padding(.top, 1.0)
        .onTapGesture(count: 1) {
            rollDice()
        }
        .onAppear {
            updateDiceArrays()
            startMotionUpdates()
        }
        .onDisappear {
            stopMotionUpdates()
        }
    }

    func rollDice() {
        guard !isRolling else { return }
        isRolling = true

        var rollsLeft = 15 // Simulate rolling for 15 stages
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            guard rollsLeft > 0 else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        diceResults = (1...numberOfDice).map { _ in Int.random(in: 1...6) }
                        updateDicePositions(in: UIScreen.main.bounds.size)
                        isRolling = false
                    }
                }
                return
            }
            withAnimation {
                diceResults = (1...numberOfDice).map { _ in Int.random(in: 1...6) }
                updateDicePositions(in: UIScreen.main.bounds.size)
            }
            rollsLeft -= 1
        }
    }

    func updateDiceArrays() {
        diceResults = Array(repeating: 1, count: numberOfDice)
        updateDicePositions(in: UIScreen.main.bounds.size)
    }

    func updateDicePositions(in size: CGSize) {
        dicePositions = []
        var attempts = 0
        let maxAttempts = 1000
        let diceSize: CGFloat = 100
        let diceSpacing: CGFloat = 10
        let minX = diceSize / 2
        let maxX = size.width - diceSize / 2
        let minY = size.height * 0.3
        let maxY = size.height * 0.7

        while dicePositions.count < numberOfDice && attempts < maxAttempts {
            let x = CGFloat.random(in: minX...maxX)
            let y = CGFloat.random(in: minY...maxY)
            let newPosition = CGPoint(x: x, y: y)
            let overlapping = dicePositions.contains { position in
                abs(position.x - newPosition.x) < (diceSize + diceSpacing) &&
                abs(position.y - newPosition.y) < (diceSize + diceSpacing)
            }

            if !overlapping {
                dicePositions.append(newPosition)
            }

            attempts += 1
        }
    }

    func startMotionUpdates() {
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            guard let acceleration = data?.acceleration else { return }
            if abs(acceleration.x) > 2 || abs(acceleration.y) > 2 || abs(acceleration.z) > 2 {
                rollDice()
            }
        }
    }

    func stopMotionUpdates() {
        motionManager.stopAccelerometerUpdates()
    }
}

struct DiceGame1_Previews: PreviewProvider {
    static var previews: some View {
        DiceGameOneView()
    }
}
