//
//  Scoreboard.swift
//  Memorize
//
//  Created by Uri on 8/4/24.
//

import SwiftUI

struct Scoreboard: View {
    
    let scores = Scorecard.stub
    
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
                    .overlay(Color.black)
                    .padding(.horizontal, -25)
                
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
                }
                
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    Scoreboard()
}

extension Scoreboard {
    
}


