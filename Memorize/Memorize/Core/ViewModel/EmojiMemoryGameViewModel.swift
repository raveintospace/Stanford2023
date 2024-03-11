//
//  EmojiMemoryGameViewModel.swift
//  Memorize
//
//  Created by Uri on 9/3/24.
//

import SwiftUI

class EmojiMemoryGameViewModel: ObservableObject {
    
    private static let emojis = ["👻", "😈", "🎃", "🕷️", "💀", "🧙🏻‍♀️", "🙀", "👹", "😱", "☠️", "🍭"]
    
    private static func createMemorizeGame() -> MemorizeGame<String> {
         return MemorizeGame(numberOfPairsOfCards: 11) { pairIndex in
             if emojis.indices.contains(pairIndex) {
                 return emojis[pairIndex]
             } else {
                 return "⁉️"
             }
         }
    }
    
    @Published private var model = createMemorizeGame()
    
    var cards: Array<MemorizeGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intents
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemorizeGame<String>.Card) {
        model.choose(card)
    }
}
