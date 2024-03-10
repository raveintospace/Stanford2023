//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Uri on 9/3/24.
//

import Foundation

struct MemorizeGame<CardContent> {
    private(set) var cards: Array<Card> // set is private, access is public
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        // add numberOfPairsOfCards x 2 equal cards, at least add 2 pairs
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    func choose(_ card: Card) {
        
    }
    
    struct Card {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        let content: CardContent
    }
}
