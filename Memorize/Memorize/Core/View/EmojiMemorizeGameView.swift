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
    
    @State private var showGameEndedAlert: Bool = false
    @State private var games: Int = 0
    
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
    private let deckWidth: CGFloat = 50
    private let dealInterval: TimeInterval = 0.05
    private let dealAnimation: Animation = .spring(duration: 0.7)
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    cards
                        .foregroundStyle(viewModel.color)
                    HStack {
                        Text("Options: \(games)")
                            .contextMenu {
                                Menu {
                                    ForEach(viewModel.memorizeDecks) { memorizeDeck in
                                        AnimatedActionButton(memorizeDeck.name) {
                                            if let index = viewModel.memorizeDecks.firstIndex(where: { $0.name == memorizeDeck.name }) {
                                                viewModel.deckIndex = index
                                            }
                                        }
                                    }
                                } label: {
                                    Label("Select deck", systemImage: "text.insert")
                                }
                            }
                        Spacer()
                        pileOfCards
                            .foregroundStyle(viewModel.color)
                        Spacer()
                        shuffleButton
                    }
                    .font(.title2)
                }
                .padding(.horizontal)
            }
            .alert(isPresented: $showGameEndedAlert) {
                Alert(title: Text("Game ended"),
                      message: Text("Do you want to play again?"),
                      primaryButton: .default(Text("Confirm")) {
                    resetGame()
                },
                      secondaryButton: .cancel())
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
    
    private func resetGame() {
        viewModel.resetGame()
        dealt = []
        lastScoreChange = (0, causedByCardId: "")
        games += 1
    }
    
    private var pileOfCards: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / cardAspectRatio)
        .onTapGesture {
            deal()
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
    }
    
    private var score: some View {
        Text("Score: \(viewModel.score)")
            .animation(nil)
    }
    
    private var matches: some View {
        Text("Matches: \(viewModel.matches)")
            .animation(nil)
    }
    
    private var shuffleButton: some View {
        Button("Shuffle") {
            withAnimation {
                viewModel.shuffle()
            }
        }
    }
}

#Preview {
    EmojiMemorizeGameView(viewModel: EmojiMemoryGameViewModel())
}
