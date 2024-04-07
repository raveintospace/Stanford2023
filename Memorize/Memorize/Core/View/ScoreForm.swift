//
//  ScoreForm.swift
//  Memorize
//
//  Created by Uri on 7/4/24.
//

import SwiftUI

struct ScoreForm: View {
    
    @ObservedObject var viewModel: EmojiMemoryGameViewModel
    
    @State private var playerName: String = ""
    @FocusState private var focused: Bool
    
    var body: some View {
        Form {
            Section(header: Text("Player name")) {
                TextField("Player name", text: $playerName)
                    .autocorrectionDisabled()
                    .focused($focused)
            }
            Section(header: Text("Deck player")) {
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
                    viewModel.saveScore(player: playerName, deck: viewModel.memorizeDecks[viewModel.deckIndex].name, matches: viewModel.matches, score: viewModel.score)
                }
                .disabled(playerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .onAppear {
            focused = true
        }
    }
}

#Preview {
    ScoreForm(viewModel: EmojiMemoryGameViewModel())
}
