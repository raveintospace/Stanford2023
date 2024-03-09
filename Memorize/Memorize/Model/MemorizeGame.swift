//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Uri on 9/3/24.
//

import Foundation

struct MemorizeGame<CardContent> {
    var cards: Array<Card>
    
    func choose(card: Card) {
        
    }
    
    struct Card {
        var isFaceUp: Bool
        var isMatched: Bool
        var content: CardContent
    }
}
