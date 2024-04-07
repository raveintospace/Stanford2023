//
//  DismissXButton.swift
//  Memorize
//
//  Created by Uri on 7/4/24.
//

import SwiftUI

struct DismissXButton: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

#Preview {
    DismissXButton()
}
