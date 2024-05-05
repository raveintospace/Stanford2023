//
//  EmojiMemoryGameViewModel.swift
//  Memorize
//
//  Created by Uri on 9/3/24.
//

import SwiftUI
import Combine

final class MemorojiViewModel: ObservableObject {
    
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
    private var scoreboardLimit: Int = 10
    
    init() {
        scoreboard = getScoreboard()
        addCustomDeckToDefaultDecks()
        setupConfirmationTimers()
    }
    
    func saveScore(player: String, deck: String, matches: Int, score: Int) {
        if isScoreboardFull() && isNewHighScore(score: score) {
            removeLowestScore()
        }
        scoreboard.append(Scorecard(player: player, deck: deck, matches: matches, score: score))
        encodeAndSaveScoreboard()
        showScoreSavedConfirmation = true
        debugPrint("new score saved: \(score)")
        debugPrint("scoreboard count: \(scoreboard.count)")
    }
    
    func isNewHighScore(score: Int) -> Bool {
        if scoreboard.isEmpty {
            return true
        }
        return scoreboard.contains { $0.score < score }
    }
    
    func isScoreboardFull() -> Bool {
        return scoreboard.count == scoreboardLimit
    }
    
    func resetScoreboard() {
        scoreboard.removeAll()
        encodeAndSaveScoreboard()
        showScoreboardResetConfirmation = true
    }
    
    private func removeLowestScore() {
        guard let lowestScore = scoreboard.min(by: { $0.score < $1.score })?.score else { return }
        if let index = scoreboard.firstIndex(where: { $0.score == lowestScore }) {
            scoreboard.remove(at: index)
        }
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
    
    // MARK: - Custom Deck
    @Published var customDeck: MemorizeDeck = MemorizeDeck(name: "", emojis: [])
    
    func saveCustomDeck(name: String, emojis: [String]) {
        removeExistingCustomDeck()
        customDeck = MemorizeDeck(name: name, emojis: emojis)
        encodeAndSaveCustomDeck()
        addCustomDeckToDefaultDecks()
        debugPrint("custom deck saved with name \(customDeck.name) and emojis \(customDeck.emojis.indices.count)")
        debugPrint("memorizedecks count after saving new custom deck: \(memorizeDecks.count)")
    }
    
    private func encodeAndSaveCustomDeck() {
        if let encoded = try? JSONEncoder().encode(customDeck) {
            UserDefaults.standard.set(encoded, forKey: "customDeck")
        }
    }
    
    private func getCustomDeck() -> MemorizeDeck? {
        if let customDeckData = UserDefaults.standard.object(forKey: "customDeck") as? Data {
            if let customDeck = try? JSONDecoder().decode(MemorizeDeck.self, from: customDeckData) {
                return customDeck
            }
        }
        return nil
    }
    
    private func addCustomDeckToDefaultDecks() {
        if let loadedCustomDeck = getCustomDeck() {
            customDeck = loadedCustomDeck
            memorizeDecks.append(loadedCustomDeck)
        }
    }
    
    func removeExistingCustomDeck() {
        if memorizeDecks.count == 10 {
            debugPrint("memorizedecks count before removing: \(memorizeDecks.count)")
            memorizeDecks.removeLast()
            customDeck = MemorizeDeck(name: "", emojis: [""])
            debugPrint("memorizedecks count after removing: \(memorizeDecks.count)")
        }
    }
    
    func createEmptyCustomDeck(name: String, emojis: [String]) {
        customDeck = MemorizeDeck(name: name, emojis: emojis)
        debugPrint("empty custom deck created")
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
        model = MemorojiViewModel.createMemorizeGame(memorizeDecks: memorizeDecks, deckIndex: deckIndex)
    }
    
    // MARK: - Confirmation rectangles
    @Published var showScoreSavedConfirmation: Bool = false
    @Published var showScoreboardResetConfirmation: Bool = false
    @Published var showCustomDeckRemovedConfirmation: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private func setupConfirmationTimers() {
        let setupTimerForConfirmation = { (confirmationFlag: Published<Bool>.Publisher) in confirmationFlag
                .filter { $0 }
                .flatMap { _ in
                    Just(false).delay(for: .seconds(2), scheduler: DispatchQueue.main)
                }
        }
        
        let scoreSavedConfirmationTimer = setupTimerForConfirmation($showScoreSavedConfirmation)
        let scoreboardResetConfirmationTimer = setupTimerForConfirmation($showScoreboardResetConfirmation)
        let customDeckRemovedConfirmationTimer = setupTimerForConfirmation($showCustomDeckRemovedConfirmation)
        
        let allConfirmationTimers = Publishers.Merge3(scoreSavedConfirmationTimer, scoreboardResetConfirmationTimer, customDeckRemovedConfirmationTimer)
        
        allConfirmationTimers
            .sink { [weak self] value in
                guard let self = self else { return }
                if value == false {
                    self.showScoreSavedConfirmation = false
                    self.showScoreboardResetConfirmation = false
                    self.showCustomDeckRemovedConfirmation = false
                }
            }
            .store(in: &cancellables)
    }
    
}
