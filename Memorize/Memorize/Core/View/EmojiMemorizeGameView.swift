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
    
    var body: some View {
        VStack {
           cards
                .foregroundColor(viewModel.color)
                .animation(.default, value: viewModel.cards) // animate when shuffle
            
            Button("Shuffle") {
                viewModel.shuffle()
            }
        }
        .padding()
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: cardAspectRatio) { card in
            CardView(card)
                .padding(spacing)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
    }
}

#Preview {
    EmojiMemorizeGameView(viewModel: EmojiMemoryGameViewModel())
}
