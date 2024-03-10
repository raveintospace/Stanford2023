//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Uri on 9/3/24.
//

import Foundation

struct MemorizeGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card> // set is private, access is public
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        // add numberOfPairsOfCards x 2 equal cards, at least add 2 pairs
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    func choose(_ card: Card) {
        
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        let content: CardContent
        
        var id: String
        
        var debugDescription: String {
            "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "")"
        }
    }
}
