//
//  EmojiMemorizeGameView.swift
//  Memorize
//
//  Created by Uri on 8/3/24.
//

import SwiftUI

struct EmojiMemorizeGameView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGameViewModel
    
    private let cardAspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    
    typealias Card = MemorizeGame<String>.Card
    
    var body: some View {
        VStack {
           cards
                .foregroundColor(viewModel.color)
            HStack {
                score
                Spacer()
                shuffleButton
            }
            .font(.title2)
        }
        .padding()
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: cardAspectRatio) { card in
            CardView(card)
                .padding(spacing)
                .overlay(FlyingNumber(number: scoreChanged(causedBy: card)))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.choose(card)
                    }
                }
        }
    }
    
    private func scoreChanged(causedBy: Card) -> Int {
        return 0
    }
    
    private var score: some View {
        Text("Score: \(viewModel.score)")
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
