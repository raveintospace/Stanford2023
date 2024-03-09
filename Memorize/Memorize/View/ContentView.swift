//
//  ContentView.swift
//  Memorize
//
//  Created by Uri on 8/3/24.
//

import SwiftUI

struct ContentView: View {
    private let emojis = ["👻", "😈", "🎃", "🕷️", "💀", "🧙🏻‍♀️", "🙀", "👹", "😱", "☠️", "🍭"]
    
    var body: some View {
        ScrollView {
            cards
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85))]) {
            ForEach(emojis.indices, id: \.self) { index in
                CardView(content: emojis[index])
                    .aspectRatio(contentMode: .fit)
            }
        }
        .foregroundColor(Color.orange)
    }
}

#Preview {
    ContentView()
}

struct CardView: View {
    let content: String
    private let base = RoundedRectangle(cornerRadius: 12)
    
    @State private var isFaceUp: Bool = true
    
    var body: some View {
        ZStack {
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content)
                    .font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            
            base.fill()
                .opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}
