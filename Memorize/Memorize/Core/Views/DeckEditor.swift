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
    
    @State private var emojiInput: String = ""
    @State private var initialCustomDeck: MemorizeDeck?
    
    @FocusState private var focused: Focused?
    
    @State private var showRemoveAlert: Bool = false
    @State private var showDismissAlert: Bool = false
    @State private var showEmptyFieldsAlert: Bool = false
    
    private let emojiFont: Font = Font.system(size: 40)
    private let textFieldMaxLength: Int = 8
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    formNameSection
                    formEmojisSection
                    Section {
                        Button("Save deck") {
                            saveDeckAndDismiss()
                        }
                        .disabled(shouldSaveBeDisallowed())
                    }
                    .alert(isPresented: $showEmptyFieldsAlert) {
                        emptyFieldsAlert()
                    }
                }
                .onAppear {
                    initialCustomDeck = editableCustomDeck
                    focusTextField()
                }
            }
            .alert(isPresented: $showDismissAlert) {
                dismissAlert()
            }
            .navigationTitle("Deck editor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    DismissXButton {
                        dismissAction()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    deleteButton
                }
            }
        }
    }
}

#Preview {
    DeckEditor(viewModel: MemorojiViewModel(), editableCustomDeck: .constant(MemorizeDeck(name: "", emojis: ["🐙"])))
}

extension DeckEditor {
    
    private var formNameSection: some View {
        Section(header: Text("Name")) {
            TextField("Set a name for your deck", text: $editableCustomDeck.name)
                .focused($focused, equals: .name)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.sentences)
                .submitLabel(.done)
                .keyboardType(.alphabet)
                .onChange(of: editableCustomDeck.name) { _, newValue in
                    let allowedInput = CharacterSet.alphanumerics
                    let filteredText = newValue.filter { character in
                        return String(character).rangeOfCharacter(from: allowedInput) != nil
                    }
                    
                    if filteredText.count > textFieldMaxLength {
                        editableCustomDeck.name = String(filteredText.prefix(textFieldMaxLength))
                    } else {
                        editableCustomDeck.name = filteredText
                    }
                }
        }
    }
    
    private var formEmojisSection: some View {
        Section(header: Text("Emojis")) {
            TextField("Add emojis here", text: $emojiInput)
                .focused($focused, equals: .addEmojis)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .disabled(editableCustomDeck.emojis.count >= 20)
                .onChange(of: emojiInput) { _, newValue in
                    let emojis = newValue.compactMap {
                        String($0).isEmoji() ? String($0) : nil
                    }
                    let uniqueEmojis = emojis.filter { !editableCustomDeck.emojis.contains($0) }
                    editableCustomDeck.emojis += uniqueEmojis
                }
            removeEmojis
        }
    }
    
    private var removeEmojis: some View {
        VStack(alignment: .trailing) {
            removeEmojisHStack
            removeEmojisLazyVGrid
        }
        .font(emojiFont)
    }
    
    private var removeEmojisHStack: some View {
        HStack {
            Text("Tap emoji to remove")
            Spacer()
            Text("Max 20 emojis")
        }
        .font(.caption)
        .foregroundStyle(Color.red)
    }
    
    private var removeEmojisLazyVGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
            ForEach(editableCustomDeck.emojis.indices, id: \.self) { index in
                let emoji = editableCustomDeck.emojis[index]
                Text(emoji)
                    .onTapGesture {
                        editableCustomDeck.emojis.remove(at: index)
                        emojiInput = emojiInput.replacingOccurrences(of: emoji, with: "")
                    }
            }
        }
    }
    
    private var deleteButton: some View {
        Button(action: {
            showRemoveAlert = true
        }, label: {
            Image(systemName: "trash")
        })
        .disabled(viewModel.memorizeDecks.count != 10)
        .alert(isPresented: $showRemoveAlert) {
            Alert(
                title: Text("Remove custom deck"),
                message: Text("Do you want to remove or keep your custom deck?"),
                primaryButton: .destructive(Text("Remove")) {
                    removeDeckAndDismiss()
                },
                secondaryButton: .default(Text("Keep"))
            )
        }
    }
    
    private func dismissAction() {
        if shouldDismiss() {
            dismiss()
        } else {
            if !shouldSaveBeDisallowed() {
                showDismissAlert = true
                debugPrint("Show dismiss alert \(showDismissAlert) ")
            } else {
                showEmptyFieldsAlert = true
            }
        }
    }
    
    private func dismissAlert() -> Alert {
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
    
    private func emptyFieldsAlert() -> Alert {
        return Alert(
            title: Text("Empty fields"),
            message: Text("Please set a name and emojis for your custom deck"),
            dismissButton: .default(Text("OK"))
        )
    }
    
    private func saveDeckAndDismiss() {
        viewModel.saveCustomDeck(name: editableCustomDeck.name, emojis: editableCustomDeck.emojis)
        viewModel.showCustomDeckSavedConfirmation = true
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
    
    private func shouldSaveBeDisallowed() -> Bool {
        let isNameEmpty = editableCustomDeck.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isCustomDeckEmojisEmpty = editableCustomDeck.emojis.isEmpty
        let emojiInputContainsNonEmojiCharacters = !emojiInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !emojiInput.isEmoji()
        
        return isNameEmpty || isCustomDeckEmojisEmpty || emojiInputContainsNonEmojiCharacters
    }
}
