//
//  EmojiMemoryGameViewModel.swift
//  Memorize
//
//  Created by Uri on 9/3/24.
//

import SwiftUI

final class EmojiMemoryGameViewModel: ObservableObject {
    
    typealias Card = MemorizeGame<String>.Card
    
    var memorizeDecks = MemorizeDeck.builtins
    
    private static func createMemorizeGame(memorizeDecks: [MemorizeDeck], deckIndex: Int) -> MemorizeGame<String> {
        return MemorizeGame(numberOfPairsOfCards: memorizeDecks[deckIndex].emojis.count) { pairIndex in
            if memorizeDecks[deckIndex].emojis.indices.contains(pairIndex) {
                return memorizeDecks[deckIndex].emojis[pairIndex]
             } else {
                 return "⁉️"
             }
         }
    }
    
    // MARK: - MemorizeDeck, starts with Halloween
    @Published var deckIndex = 5
    
    // MARK: - MemorizeGame
    @Published private var model = createMemorizeGame(memorizeDecks: MemorizeDeck.builtins, deckIndex: 5)
    
    var cards: Array<Card> {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    var matches: Int {
        model.matches
    }
    
    @Published var color: Color = .orange
    
    func isGameFinished() -> Bool {
        if matches == memorizeDecks[deckIndex].emojis.count {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Scoreboard
    @Published var scoreboard: [Scorecard] = []
    
    init() {
        scoreboard = getScoreboard()
        debugPrint("scoreboard count: \(scoreboard.count)")
    }
    
    @Published var showScoreSavedConfirmation: Bool = false
    
    func saveScore(player: String, deck: String, matches: Int, score: Int) {
        if scoreboard.count < 10 {
            scoreboard.append(Scorecard(player: player, deck: deck, matches: matches, score: score))
            debugPrint("new score saved: \(score)")
            debugPrint("scoreboard count: \(scoreboard.count)")
        }
    }
    
    func isNewHighScore(score: Int) -> Bool {
        guard let highestScore = scoreboard.map({ $0.score }).max() else {
            return true // when scoreboard is empty it will be a highScore
        }
        return score > highestScore
    }
    
    func isScoreboardFull() -> Bool {
        return scoreboard.count >= 10
    }
    
    private func encodeAndSaveScoreboard() {
        if let encoded = try? JSONEncoder().encode(scoreboard) {
            UserDefaults.standard.set(encoded, forKey: "scoreboard")
        }
    }
    
    private func getScoreboard() -> [Scorecard] {
        if let scoreboardData = UserDefaults.standard.object(forKey: "scoreboard") as? Data {
            if let scoreboard = try? JSONDecoder().decode([Scorecard].self, from: scoreboardData) {
                return scoreboard
            }
        }
        return []
    }
    
    // MARK: - Intents
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func resetGame() {
        model.resetGame()
        model = EmojiMemoryGameViewModel.createMemorizeGame(memorizeDecks: memorizeDecks, deckIndex: deckIndex)
    }
}
