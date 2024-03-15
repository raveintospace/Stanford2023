//
//  EmojiMemoryGameViewModel.swift
//  Memorize
//
//  Created by Uri on 9/3/24.
//

import SwiftUI

class EmojiMemoryGameViewModel: ObservableObject {
    
    typealias Card = MemorizeGame<String>.Card
    
    private static let emojis = ["👻", "😈", "🎃", "🕷️", "💀", "🧙🏻‍♀️", "🙀", "👹", "😱", "☠️", "🍭"]
    
    private static func createMemorizeGame() -> MemorizeGame<String> {
         return MemorizeGame(numberOfPairsOfCards: 2) { pairIndex in
             if emojis.indices.contains(pairIndex) {
                 return emojis[pairIndex]
             } else {
                 return "⁉️"
             }
         }
    }
    
    @Published private var model = createMemorizeGame()
    
    var cards: Array<Card> {
        model.cards
    }
    
    var color: Color {
        .orange
    }
    
    // MARK: - Intents
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
}
