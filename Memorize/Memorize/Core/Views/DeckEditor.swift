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
    
    @ObservedObject var viewModel: MemorojiViewModel
    
    @Binding var editableCustomDeck: MemorizeDeck
    
    @Environment(\.dismiss) var dismiss
    
    @State private var deckName: String = ""
    @State private var emojiInput: String = ""
    
    @FocusState private var focused: Focused?
    
    @State private var showRemoveAlert: Bool = false
    
    private let emojiFont: Font = Font.system(size: 40)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section(header: Text("Name")) {
                        TextField("Name", text: $editableCustomDeck.name)
                            .focused($focused, equals: .name)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.words)
                        // limit length of name
                    }
                    Section(header: Text("Emojis")) {
                        TextField("Add emojis here", text: $emojiInput)
                        .focused($focused, equals: .addEmojis)
                        .autocorrectionDisabled()
                        .font(emojiFont)
                        .onChange(of: emojiInput) { _, newValue in
                            let emojis = newValue.compactMap {
                                String($0).isEmoji() ? String($0) : nil
                            }
                            let uniqueEmojis = Array(Set(emojis))
                            editableCustomDeck.emojis = uniqueEmojis
                        }
                        removeEmojis
                    }
                    Section {
                        Button("Save deck") {
                            saveDeck()
                            dismiss()
                        }
                        .disabled(editableCustomDeck.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                .onAppear {
                    focusTextField()
                }
                .alert(isPresented: $showRemoveAlert) {
                    Alert(
                        title: Text("Remove custom deck"),
                        message: Text("Do you want to remove your custom deck?"),
                        primaryButton: .default(Text("Discard")),
                        secondaryButton: .destructive(Text("Remove")) {
                            removeDeck()
                            dismiss()
                        }
                    )
                }
            }
            .navigationTitle("Deck editor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    DismissXButton(customAction: nil)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    deleteButton
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(action: {
                        UIApplication.shared.hideKeyboard()
                    }, label: {
                        Text("Done")
                    })
                }
            }
        }
    }
}

#Preview {
    DeckEditor(viewModel: MemorojiViewModel(), editableCustomDeck: .constant(MemorizeDeck(name: "", emojis: [""])))
}

extension DeckEditor {
    
    private var removeEmojis: some View {
        VStack(alignment: .trailing) {
            Text("Tap emoji to remove")
                .font(.caption)
                .foregroundStyle(Color.red)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(editableCustomDeck.emojis.indices, id: \.self) { index in
                    let emoji = editableCustomDeck.emojis[index]
                    Text(emoji)
//                        .onTapGesture {
//                            withAnimation {
//                                editableCustomDeck.emojis.remove(at: index)
//                                if let indexToRemove = emojisToAdd.firstIndex(of: emoji) {
//                                    emojisToAdd.remove(at: indexToRemove)
//                                }
//                            }
//                        }
                }
            }
        }
        .font(emojiFont)
    }
    
    private var deleteButton: some View {
        Button(action: {
            showRemoveAlert = true
        }, label: {
            Image(systemName: "trash")
        })
        .disabled(viewModel.memorizeDecks.count != 10)
        
    }
    
    private func saveDeck() {
        viewModel.saveCustomDeck(name: editableCustomDeck.name, emojis: editableCustomDeck.emojis)
    }
    
    private func removeDeck() {
        viewModel.removeExistingCustomDeck()
        viewModel.showCustomDeckRemovedConfirmation = true
    }
    
    private func focusTextField() {
        if editableCustomDeck.name.isEmpty {
            focused = .name
        } else {
            focused = .addEmojis
        }
    }
}
