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

struct DeckEditor: View {
    
    @Binding var deck: MemorizeDeck
    
    @Environment(\.dismiss) var dismiss
    
    @State private var emojisToAdd: [String] = []
    
    @FocusState private var focused: Focused?
    
    private let emojiFont: Font = Font.system(size: 40)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section(header: Text("Name")) {
                        TextField("Name", text: $deck.name)
                            .focused($focused, equals: .name)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.words)
                        // limit length of name
                        
                    }
                    Section(header: Text("Emojis")) {
                        TextField("Add emojis here", text: .constant(emojisToAdd.joined()))
                            .focused($focused, equals: .addEmojis)
                            .autocorrectionDisabled()
                            .font(emojiFont)
                            .onChange(of: emojisToAdd) { _, newValue in
                                let newEmojis = newValue.filter { $0.isEmoji() }
                                let uniqueEmojis = newEmojis.filter { !deck.emojis.contains($0)
                                }
                                deck.emojis.append(contentsOf: uniqueEmojis)
                            }
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
            .navigationTitle("Deck editor")
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
    DeckEditor(deck: .constant(MemorizeDeck(name: "Preview", emojis: ["🐥", "🏋🏻‍♂️", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🐲", "🐙"])))
}

extension DeckEditor {
    
    private var removeEmojis: some View {
        VStack(alignment: .trailing) {
            Text("Tap emoji to remove")
                .font(.caption)
                .foregroundStyle(Color.red)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(deck.emojis.indices, id: \.self) { index in
                    let emoji = deck.emojis[index]
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                deck.emojis.remove(at: index)
                                if let indexToRemove = emojisToAdd.firstIndex(of: emoji) {
                                    emojisToAdd.remove(at: indexToRemove)
                                }
                            }
                        }
                }
            }
        }
        .font(emojiFont)
    }
}
