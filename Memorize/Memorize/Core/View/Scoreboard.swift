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
        Grid(horizontalSpacing: 500, verticalSpacing: 20) {
            GridRow {
                titlesRow
            }
            Divider()
                .frame(minHeight: 3)
                .overlay(Color.black)
            scoreList
        }
    }
}

#Preview {
    Scoreboard()
}

extension Scoreboard {
    
    private var titlesRow: some View {
        HStack {
            Text("Player")
                .background(Color.blue)
            Spacer()
            Text("Deck")
                .background(Color.red)
            Spacer()
            Text("Matches")
                .background(Color.yellow)
            Spacer()
            Text("Score")
                .background(Color.green)
        }
        .padding(.horizontal)
    }
    
    private var scoreList: some View {
        ForEach(scores) { score in
            HStack {
                Text(score.player)
                Spacer()
                Text(score.deck)
                Spacer()
                Text("\(score.matches)")
                Spacer()
                Text("\(score.score)")
                Spacer()
            }
            .padding(.horizontal)
            Divider()
                .frame(minHeight: 1)
                .overlay(Color.black)
        }
    }
}
