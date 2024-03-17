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
    
    private struct Constants {
        static let inset: CGFloat = 5
        
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest / largest
        }
        
        struct Pie {
            static let opacity: CGFloat = 0.5
            static let inset: CGFloat = 5
        }
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            if card.isFaceUp || !card.isMatched {
                PieShape(endAngle: .degrees(card.bonusPercentRemaining * 360))
                    .opacity(Constants.Pie.opacity)
                    .overlay {
                        cardContents
                            .padding(Constants.Pie.inset)
                    }
                    .padding(Constants.inset)
                    .cardify(isFaceUp: card.isFaceUp)
            } else {
                Color.clear // keep the space of matched cards that disappear
            }
        }
    }
    
    private var cardContents: some View {
        Text(card.content)
            .font(.system(size: Constants.FontSize.largest))
            .minimumScaleFactor(Constants.FontSize.scaleFactor)
            .multilineTextAlignment(.center)
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
            .animation(.spin(duration: 0.7), value: card.isMatched)
    }
}

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .linear(duration: duration).repeatCount(3, autoreverses: false)
    }
}

struct CardView_Previews: PreviewProvider {
    typealias Card = CardView.Card
    
    static var previews: some View {
        VStack {
            HStack {
                CardView(Card(isFaceUp: true, content: "X", id: "test1"))
                    .aspectRatio(4/3, contentMode: .fit)
                CardView(Card(content: "X", id: "test1"))
            }
            HStack {
                CardView(Card(isFaceUp: true, isMatched: true, content: "This is a very long string and I hope it fits", id: "test1"))
                CardView(Card(isMatched: true, content: "X", id: "test1"))
            }
        }
        .padding()
        .foregroundStyle(Color.green)
    }
}
