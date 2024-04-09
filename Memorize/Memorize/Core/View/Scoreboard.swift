//
//  Scoreboard.swift
//  Memorize
//
//  Created by Uri on 8/4/24.
//

import SwiftUI

struct Scoreboard: View {
    
    @ObservedObject var viewModel: EmojiMemoryGameViewModel
    
    let scores = Scorecard.stub // update with real data
    
    var body: some View {
        ScrollView {
            Grid(alignment: .leadingFirstTextBaseline,
                 horizontalSpacing: 15,
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
                
                ForEach(scores) { score in
                    GridRow(alignment: .center) {
                        Text(score.player)
                        Text(score.deck)
                            .gridColumnAlignment(.center)
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
    }
}

#Preview {
    Scoreboard(viewModel: EmojiMemoryGameViewModel())
}


