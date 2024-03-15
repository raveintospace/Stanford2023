//
//  CardView.swift
//  Memorize
//
//  Created by Uri on 15/3/24.
//

import SwiftUI

struct CardView: View {
    
    typealias Card = MemorizeGame<String>.Card
    
    let card: Card
    
    // init to avoid the external parameter name
    init(_ card: Card) {
        self.card = card
    }
    
    private let base = RoundedRectangle(cornerRadius: 12)
    
    var body: some View {
        ZStack {
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            
            base.fill()
                .opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

struct CardView_Previews: PreviewProvider {
    typealias Card = MemorizeGame<String>.Card
    
    static var previews: some View {
        CardView(Card(content: "X", id: "test1"))
            .padding()
            .foregroundStyle(Color.green)
    }
}
