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
    @State private var initialCustomDeck: MemorizeDeck?
    
    @FocusState private var focused: Focused?
    
    @State private var showRemoveAlert: Bool = false
    @State private var showDismissAlert: Bool = false
    
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
                            let uniqueEmojis = emojis.filter { !editableCustomDeck.emojis.contains($0) }
                            editableCustomDeck.emojis += uniqueEmojis
                        }
                        // limit to max 20 emojis
                        removeEmojis
                    }
                    Section {
                        Button("Save deck") {
                            saveDeckAndDismiss()
                        }
                        .disabled(shouldSaveButtonBeDisabled())
                    }
                }
                .onAppear {
                    initialCustomDeck = editableCustomDeck
                    focusTextField()
                }
                .alert(isPresented: $showRemoveAlert) {
                    Alert(
                        title: Text("Remove custom deck"),
                        message: Text("Do you want to remove your custom deck?"),
                        primaryButton: .default(Text("Discard")),
                        secondaryButton: .destructive(Text("Remove")) {
                            removeDeckAndDismiss()
                        }
                    )
                }
                .alert(isPresented: $showDismissAlert) {
                    
                    guard let initialDeck = initialCustomDeck else {
                        return Alert(
                            title: Text("Error"),
                            message: Text("Initial deck is missing"),
                            dismissButton: .default(Text("OK")))
                    }
                    
                    return Alert(
                        title: Text("Changes not saved"),
                        message: Text("Do you want to discard or save the changes made?"),
                        primaryButton: .destructive(Text("Discard")) {
                            editableCustomDeck = initialDeck
                            dismiss()
                        },
                        secondaryButton: .default(Text("Save")) {
                            saveDeckAndDismiss()
                        }
                    )
                }
                
            }
            .navigationTitle("Deck editor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    DismissXButton {
                        if shouldDismiss() {
                            dismiss()
                        } else {
                            showDismissAlert = true
                        }
                    }
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
    DeckEditor(viewModel: MemorojiViewModel(), editableCustomDeck: .constant(MemorizeDeck(name: "", emojis: [])))
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
                        .onTapGesture {
                            withAnimation {
                                editableCustomDeck.emojis.remove(at: index)
                                emojiInput = emojiInput.replacingOccurrences(of: emoji, with: "")
                            }
                        }
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
    
    private func saveDeckAndDismiss() {
        viewModel.saveCustomDeck(name: editableCustomDeck.name, emojis: editableCustomDeck.emojis)
        dismiss()
    }
    
    private func removeDeckAndDismiss() {
        viewModel.removeExistingCustomDeck()
        viewModel.showCustomDeckRemovedConfirmation = true
        dismiss()
    }
    
    private func focusTextField() {
        if editableCustomDeck.name.isEmpty {
            focused = .name
        } else {
            focused = .addEmojis
        }
    }
    
    private func shouldDismiss() -> Bool {
        guard let initialCustomDeck = initialCustomDeck else { return true }
        return initialCustomDeck == editableCustomDeck
    }
    
    private func shouldSaveButtonBeDisabled() -> Bool {
        let isNameEmpty = editableCustomDeck.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isCustomDeckEmojisEmpty = editableCustomDeck.emojis.isEmpty
        let emojiInputContainsNonEmojiCharacters = !emojiInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !emojiInput.isEmoji()
        
        return isNameEmpty || isCustomDeckEmojisEmpty || emojiInputContainsNonEmojiCharacters
    }
}
