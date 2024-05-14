//
//  EmojiMemorizeGameView.swift
//  Memorize
//
//  Created by Uri on 8/3/24.
//

import SwiftUI
import AVKit

enum SheetType: String, Identifiable {
    case creditsView, deckEditor, scoreboard, scoreForm
    var id: String { rawValue }
}

struct MemorojiView: View {
    
    typealias Card = MemorizeGame<String>.Card
    
    @ObservedObject var viewModel: MemorojiViewModel
    
    @State private var hasGameStarted: Bool = false
    @State private var showGameEndedAlert: Bool = false
    @State private var showDeckEditorAlert: Bool = false
    
    @State private var sheetType: SheetType?
    
    // Tuple with Int & Card.Id as parameters, tracks card with score
    @State private var lastScoreChange = (0, causedByCardId: "")
    
    // Initial dealt of cards, shows the pileOfCards at the bottom of view
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }
    
    private let cardAspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    private let pileOfCardsWidth: CGFloat = 50
    private let dealInterval: TimeInterval = 0.05
    private let dealAnimation: Animation = .spring(duration: 0.7)
    
    // Sound management
    private let soundPlayer = SoundPlayer()
    
    // Adapts to user's Dynamic Type
    @ScaledMetric var optionsButtonSize: CGFloat = 50
    
    // Synchronizes animation from undealt to dealt
    @Namespace private var dealingNamespace
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    cards
                    pileOfCards
                    gameButtons
                }
                .padding(.horizontal)
            }
            .confirmationDialog("Game ended 🎉 \nWhat do you want to do now?", isPresented: $showGameEndedAlert, titleVisibility: .visible) {
                saveScoreButton
                playAgainButton
                quitGameButton
            }
            .alert(isPresented: $showDeckEditorAlert) {
                Alert(
                    title: Text("Custom deck selected"),
                    message: Text("Please select another deck before editing the custom one"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .sheet(item: $sheetType, content: makeSheet)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    score
                }
                ToolbarItem(placement: .topBarTrailing) {
                    matches
                }
            }
            .navigationTitle("\(viewModel.memorizeDecks[viewModel.deckIndex].name)")
            .navigationBarTitleDisplayMode(.inline)
        }
        .safeAreaInset(edge: .bottom) {
            confirmationRectangles
        }
    }
}

#Preview {
    MemorojiView(viewModel: MemorojiViewModel())
}

extension MemorojiView {
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: cardAspectRatio) { card in
            if isDealt(card) {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(spacing)
                    .overlay(FlyingNumber(number: scoreChanged(causedBy: card)))
                    .zIndex(scoreChanged(causedBy: card) != 0 ? 1 : 0)
                    .onTapGesture {
                        choose(card)
                    }
            }
        }
        .foregroundStyle(viewModel.color)
    }
    
    private var pileOfCards: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .foregroundStyle(viewModel.color)
        .frame(width: pileOfCardsWidth, height: pileOfCardsWidth / cardAspectRatio)
    }
    
    private var gameButtons: some View {
        HStack {
            options
            Spacer()
            if !hasGameStarted {
                startButton
            } else {
                restartButton
            }
        }
        .padding(.top, 0)
    }
    
    private func scoreChanged(causedBy card: Card) -> Int {
        let (amount, causedByCardId: id) = lastScoreChange
        return card.id == id ? amount : 0
    }
    
    private func choose(_ card: Card) {
        withAnimation(.easeInOut(duration: 0.5)) {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
            
            if viewModel.isGameFinished() {
                
                if viewModel.soundActivated {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        soundPlayer.play(withURL: viewModel.gameFinishedSound.getURL())
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showGameEndedAlert = true
                }
            }
        }
    }
    
    private func deal() {
        if viewModel.soundActivated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                soundPlayer.play(withURL: viewModel.dealSound.getURL())
            }
        }
        
        //viewModel.shuffle()
        
        var delay: TimeInterval = 0
        for card in viewModel.cards {
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealt.insert(card.id)   // _ = to avoid a warning
            }
            delay += dealInterval
        }
        
        hasGameStarted = true
    }
    
    private func resetGame() {
        viewModel.resetGame()
        dealt = []
        lastScoreChange = (0, causedByCardId: "")
        hasGameStarted = false
    }
    
    // MARK: - Toolbar & Buttons
    private var score: some View {
        Text("Score: \(viewModel.score)")
            .animation(nil)
    }
    
    private var matches: some View {
        Text("Matches: \(viewModel.matches)")
            .animation(nil)
    }
    
    private var options: some View {
        Menu {
            AnimatedActionButton(NSLocalizedString("See app info", comment: "")) {
                sheetType = .creditsView
            }
            AnimatedActionButton(NSLocalizedString("See scoreboard", comment: "")) {
                sheetType = .scoreboard
            }
            Menu {
                ForEach(viewModel.memorizeDecks.sorted(by: { $0.name > $1.name })) { memorizeDeck in
                    AnimatedActionButton(memorizeDeck.name) {
                        if let index = viewModel.memorizeDecks.firstIndex(where: { $0.name == memorizeDeck.name }) {
                            viewModel.deckIndex = index
                            resetGame()
                        }
                    }
                }
            } label: {
                Text("Select deck")
            }
            Menu {
                ForEach(CardColor.allCases.sorted(by: { $0.description > $1.description }), id: \.self) { deckColor in
                    Button(deckColor.description) {
                        viewModel.color = deckColor.color
                    }
                }
            } label: {
                Text("Set card color")
            }
            AnimatedActionButton(NSLocalizedString(customDeckString, comment: "")) {
                if viewModel.deckIndex == 9 {
                    showDeckEditorAlert = true
                } else {
                    sheetType = .deckEditor
                }
            }
            AnimatedActionButton(NSLocalizedString(customSoundString, comment: "")) {
                viewModel.soundActivated.toggle()
            }
        } label: {
            Image(systemName: "gearshape.2")
                .font(.system(size: optionsButtonSize))
        }
    }
    
    private var customDeckString: String {
        if viewModel.memorizeDecks.count == 10 {
            return "Edit custom deck"
        } else {
            return "Create custom deck"
        }
    }
    
    private var customSoundString: String {
        if viewModel.soundActivated {
            return "🔇 Mute sound 🔇"
        } else {
            return "🔊 Activate sound 🔊"
        }
    }
    
    private var startButton: some View {
        Button("Start") {
            deal()
        }
        .font(.title)
    }
    
    private var restartButton: some View {
        Button(viewModel.isGameFinished() ? "Play again" : "Restart") {
            resetGame()
        }
        .font(.title)
    }
    
    private var playAgainButton: some View {
        Button("Play again") {
            resetGame()
        }
    }
    
    private var saveScoreButton: some View {
        Button("Save score") {
            sheetType = .scoreForm
        }
        .disabled(viewModel.isScoreboardFull() && !viewModel.isNewHighScore(score: viewModel.score))
    }
    
    private var quitGameButton: some View {
        Button("Quit game", role: .destructive) {
            sheetType = .creditsView
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                resetGame()
            }
        }
    }
    
    // MARK: - Confirmation rectangles
    private var confirmationRectangles: some View {
        Group {
            if viewModel.showScoreSavedConfirmation {
                ConfirmationRectangle(copy: "Score saved", iconName: "checkmark.seal")
            } else if viewModel.showScoreboardResetConfirmation {
                ConfirmationRectangle(copy: "Scoreboard reset", iconName: "text.badge.minus")
            } else if viewModel.showCustomDeckRemovedConfirmation {
                ConfirmationRectangle(copy: "Custom deck removed", iconName: "pencil.slash")
            } else if viewModel.showCustomDeckSavedConfirmation {
                ConfirmationRectangle(copy: "Custom deck saved", iconName: "pencil.and.scribble")
            }
        }
    }
    
    // MARK: - Sheet presentation
    @ViewBuilder
    func makeSheet(_ sheetType: SheetType) -> some View {
        switch sheetType {
        case .creditsView:
            CreditsView().interactiveDismissDisabled()
        case .scoreboard:
            Scoreboard(viewModel: viewModel).interactiveDismissDisabled()
        case .scoreForm:
            ScoreForm(viewModel: viewModel).interactiveDismissDisabled()
        case .deckEditor:
            DeckEditor(viewModel: viewModel, editableCustomDeck: $viewModel.customDeck)
                .interactiveDismissDisabled()
        }
    }
}
