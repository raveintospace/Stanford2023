//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Uri on 9/3/24.
//

import SwiftUI

func createCardContent(forPairAtIndex index: Int) -> String {
    return ["👻", "😈", "🎃", "🕷️", "💀", "🧙🏻‍♀️", "🙀", "👹", "😱", "☠️", "🍭"][index]
}

class EmojiMemoryGame {
    private var model = MemorizeGame(
        numberOfPairsOfCards: 4,
        cardContentFactory: { (index: Int) -> String in
            return ["👻", "😈", "🎃", "🕷️", "💀", "🧙🏻‍♀️", "🙀", "👹", "😱", "☠️", "🍭"][index]
        })
    
    var cards: Array<MemorizeGame<String>.Card> {
        return model.cards
    }
    
    func choose(_ card: MemorizeGame<String>.Card) {
        model.choose(card)
    }
    
    init(model: MemorizeGame<String>) {
        self.model = model
    }
}
