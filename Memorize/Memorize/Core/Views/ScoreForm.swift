//
//  ScoreForm.swift
//  Memorize
//
//  Created by Uri on 7/4/24.
//

import SwiftUI

struct ScoreForm: View {
    
    @ObservedObject var viewModel: EmojiMemoryGameViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var playerName: String = ""
    @FocusState private var playerNameFocused: Bool
    
    @State private var showDismissAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section(header: Text("Player name")) {
                        TextField("Player name", text: $playerName)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.words)
                            .focused($playerNameFocused)
                            .onChange(of: playerName) { if playerName.count > 20 { playerName = String(String(playerName).prefix(20)) }
                            }
                    }
                    Section(header: Text("Deck played")) {
                        Text("\(viewModel.memorizeDecks[viewModel.deckIndex].name)")
                    }
                    Section(header: Text("Total matches")) {
                        Text("\(viewModel.matches)")
                    }
                    Section(header:
                                Text("Final score")
                        .bold()
                        .font(.title)
                    ) {
                        Text("\(viewModel.score)")
                            .bold()
                            .font(.largeTitle)
                    }
                    Section {
                        Button("Save score") {
                            saveScore()
                            dismiss()
                        }
                        .disabled(playerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                .onAppear {
                    playerNameFocused = true
                }
                .alert(isPresented: $showDismissAlert) {
                    Alert(
                        title: Text("Exit screen"),
                        message: Text("You will lose your score if you press Exit"),
                        primaryButton: .default(Text("Keep editing")),
                        secondaryButton: .destructive(Text("Exit")) { dismiss() }
                    )
                }
            }
            .navigationTitle("Save your score")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    DismissXButton {
                        showDismissAlert = true
                    }
                }
            }
        }
    }
}

#Preview {
    ScoreForm(viewModel: EmojiMemoryGameViewModel())
}

extension ScoreForm {
    
    private func saveScore() {
        viewModel.saveScore(player: playerName, deck: viewModel.memorizeDecks[viewModel.deckIndex].name, matches: viewModel.matches, score: viewModel.score)
        viewModel.showScoreSavedConfirmation = true
    }
}
