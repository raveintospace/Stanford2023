//
//  MaxLengthTextField.swift
//  Memorize
//
//  Created by Uri on 5/5/24.
//

import SwiftUI
import Combine

struct MaxLengthTextField: View {
    @Binding var text: String
    let placeholder: String
    let maxLength: Int

    var body: some View {
        TextField(placeholder, text: $text)
            .onReceive(Just(text)) { newValue in
                let trimmedValue = String(newValue.prefix(maxLength))
                if trimmedValue != newValue {
                    self.text = trimmedValue
                }
            }
    }
}

#Preview {
    MaxLengthTextField(text: .constant("Your name"), placeholder: "Set your name", maxLength: 15)
}
