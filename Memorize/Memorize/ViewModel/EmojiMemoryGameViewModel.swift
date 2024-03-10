//
//  EmojiMemoryGameViewModel.swift
//  Memorize
//
//  Created by Uri on 9/3/24.
//

import SwiftUI

class EmojiMemoryGameViewModel {
    
    private static let emojis = ["👻", "😈", "🎃", "🕷️", "💀", "🧙🏻‍♀️", "🙀", "👹", "😱", "☠️", "🍭"]
    
    private static func createMemorizeGame() -> MemorizeGame<String> {
         return MemorizeGame(numberOfPairsOfCards: 6) { pairIndex in
             if emojis.indices.contains(pairIndex) {
                 return emojis[pairIndex]
             } else {
                 return "⁉️"
             }
         }
    }
    
    private var model = createMemorizeGame()
    
    var cards: Array<MemorizeGame<String>.Card> {
        return model.cards
    }
    
    func choose(_ card: MemorizeGame<String>.Card) {
        model.choose(card)
    }
}
