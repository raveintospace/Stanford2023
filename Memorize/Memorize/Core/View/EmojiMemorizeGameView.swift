//
//  EmojiMemorizeGameView.swift
//  Memorize
//
//  Created by Uri on 8/3/24.
//

import SwiftUI

struct EmojiMemorizeGameView: View {
    
    typealias Card = MemorizeGame<String>.Card
    
    @ObservedObject var viewModel: EmojiMemoryGameViewModel
    
    @State private var hasGameStarted: Bool = false
    @State private var showGameEndedAlert: Bool = false
    @State private var games: Int = 0   // remove on final version of app
    
    // tuple with Int & Card.Id as parameters, tracks card with score
    @State private var lastScoreChange = (0, causedByCardId: "")
    
    // initial dealt of cards, shows the pileOfCards at the bottom of view
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }
    
    private let cardAspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    private let pileOfCardsWidth: CGFloat = 50
    private let dealInterval: TimeInterval = 0.05
    private let dealAnimation: Animation = .spring(duration: 0.7)
    
    @ScaledMetric var optionsButtonSize: CGFloat = 50
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    cards
                    pileOfCards
                    gameButtons
                }
                .padding(.horizontal)
            }
            .confirmationDialog("Game ended 🎉 \nWhat do you want to do now?", isPresented: $showGameEndedAlert, titleVisibility: .visible) {
                Button("Play again") {
                    resetGame()
                }
                Button("Save score") {
                    debugPrint("Save Score with userDefault, reset game after saving")
                }
                Button("Quit game", role: .destructive) {
                    debugPrint("Show credits")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    score
                }
                ToolbarItem(placement: .topBarTrailing) {
                    matches
                }
            }
        }
    }
}

#Preview {
    EmojiMemorizeGameView(viewModel: EmojiMemoryGameViewModel())
}

extension EmojiMemorizeGameView {
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: cardAspectRatio) { card in
            if isDealt(card) {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(spacing)
                    .overlay(FlyingNumber(number: scoreChanged(causedBy: card)))
                    .zIndex(scoreChanged(causedBy: card) != 0 ? 1 : 0)
                    .onTapGesture {
                        choose(card)
                    }
            }
        }
        .foregroundStyle(viewModel.color)
    }
    
    private var pileOfCards: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .foregroundStyle(viewModel.color)
        .frame(width: pileOfCardsWidth, height: pileOfCardsWidth / cardAspectRatio)
    }
    
    private var gameButtons: some View {
        HStack {
            options
            Spacer()
            if !hasGameStarted {
                startButton
            } else {
                restartButton
            }
        }
        .padding(.top, 0)
    }
    
    private func scoreChanged(causedBy card: Card) -> Int {
        let (amount, causedByCardId: id) = lastScoreChange
        return card.id == id ? amount : 0
    }
    
    private func choose(_ card: Card) {
        withAnimation(.easeInOut(duration: 0.5)) {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
            
            if viewModel.isGameFinished() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showGameEndedAlert = true
                }
            }
        }
    }
    
    private func deal() {
        //viewModel.shuffle()
        
        var delay: TimeInterval = 0
        for card in viewModel.cards {
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealt.insert(card.id)   // _ = to avoid a warning
            }
            delay += dealInterval
        }
        
        hasGameStarted = true
    }
    
    private func resetGame() {
        viewModel.resetGame()
        dealt = []
        lastScoreChange = (0, causedByCardId: "")
        hasGameStarted = false
        games += 1  // remove on final version of app
    }
    
    // MARK: - Toolbar & Buttons
    
    private var score: some View {
        Text("Score: \(viewModel.score)")
            .animation(nil)
    }
    
    private var matches: some View {
        Text("Matches: \(viewModel.matches)")
            .animation(nil)
    }
    
    private var options: some View {
        Menu {
            Menu {
                ForEach(viewModel.memorizeDecks.sorted(by: { $0.name > $1.name })) { memorizeDeck in
                    AnimatedActionButton(memorizeDeck.name) {
                        if let index = viewModel.memorizeDecks.firstIndex(where: { $0.name == memorizeDeck.name }) {
                            viewModel.deckIndex = index
                            resetGame()
                        }
                    }
                }
            } label: {
                Text("Select deck")
            }
            Menu {
               Text("update to AnimatedActionButton and show a sheet")
            } label : {
                Text("See scoreboard")
            }
            Menu {
                ForEach(CardColor.allCases.sorted(by: { $0.description > $1.description }), id: \.self) { deckColor in
                    Button(deckColor.description) {
                        viewModel.color = deckColor.color
                    }
                }
            } label: {
                Text("Set card color")
            }
        } label: {
            Image(systemName: "gearshape.2")
                .font(.system(size: optionsButtonSize))
        }
    }
    
    private var startButton: some View {
        Button("Start") {
            deal()
        }
        .font(.title)
    }
    
    private var restartButton: some View {
        Button("Restart") {
            debugPrint("Restart pressed")
        }
        .font(.title)
    }
}
