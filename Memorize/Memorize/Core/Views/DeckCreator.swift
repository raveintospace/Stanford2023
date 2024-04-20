//
//  DeckCreator.swift
//  Memorize
//
//  Created by Uri on 20/4/24.
//

import SwiftUI

enum Focused {
    case name
    case addEmojis
}

struct DeckCreator: View {
    
    @Binding var deck: MemorizeDeck
    
    @State private var emojisToAdd: String = ""
    @FocusState private var focused: Focused?
    
    private let emojiFont: Font = Font.system(size: 40)
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $deck.name)
                    .focused($focused, equals: .name)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.words)
            }
            Section(header: Text("Emojis")) {
                TextField("Add emojis here", text: $emojisToAdd)
                    .focused($focused, equals: .addEmojis)
                    .autocorrectionDisabled()
                    .font(emojiFont)
//                    .onChange(of: emojisToAdd) { _, newValue in
//                        deck.emojis = (newValue + deck.emojis)
//                            .filter { $0.isEmoji }
//                            .uniqued
//                    }
                removeEmojis
            }
        }
        .onAppear {
            if deck.name.isEmpty {
                focused = .name
            } else {
                focused = .addEmojis
            }
        }
    }
}

#Preview {
    DeckCreator(deck: .constant(MemorizeDeck(name: "Preview", emojis: ["🐥", "🏋🏻‍♂️"])))
}

extension DeckCreator {
    
    private var removeEmojis: some View {
        VStack(alignment: .trailing) {
            Text("Tap emoji to remove")
                .font(.caption)
                .foregroundStyle(Color.red)
            Text("Test")
//            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
//                ForEach(deck.emojis.uniqued.map(String.init), id: \.self) { emoji in
//                    Text(emoji)
//                        .onTapGesture {
//                            withAnimation {
//                                deck.emojis.remove(emoji.first!)
//                                emojisToAdd.remove(emoji.first!)
//                            }
//                        }
//                }
//            }
        }
        .font(emojiFont)
    }
}
