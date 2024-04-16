//
//  Scoreboard.swift
//  Memorize
//
//  Created by Uri on 8/4/24.
//

import SwiftUI

struct Scoreboard: View {
    
    @ObservedObject var viewModel: EmojiMemoryGameViewModel
    
    @Environment(\.dismiss) var dismiss
    
    //let scores = Scorecard.stub // update with real data
    
    //let scores = viewModel.scoreboard
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    Grid(alignment: .leadingFirstTextBaseline,
                         horizontalSpacing: 20,
                         verticalSpacing: 10) {
                        GridRow {
                            Text("PLAYER")
                            Text("DECK")
                                .gridColumnAlignment(.center)
                            Text("MATCHES")
                                .gridColumnAlignment(.center)
                            Text("SCORE")
                                .gridColumnAlignment(.trailing)
                        }
                        .font(.callout)
                        
                        Divider()
                            .frame(minHeight: 3)
                            .overlay(viewModel.color)
                        
                        ForEach(viewModel.scoreboard) { score in
                            GridRow(alignment: .center) {
                                Text(score.player)
                                Text(score.deck)
                                    .gridColumnAlignment(.center)
                                    .multilineTextAlignment(.center)
                                Text("\(score.matches)")
                                    .gridColumnAlignment(.center)
                                Text("\(score.score)")
                                    .gridColumnAlignment(.trailing)
                            }
                            Divider()
                                .frame(minHeight: 1)
                                .overlay(viewModel.color.opacity(0.5))
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .navigationTitle("Scoreboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    DismissXButton(customAction: nil)
                }
            }
        }
    }
}

#Preview {
    Scoreboard(viewModel: EmojiMemoryGameViewModel())
}


