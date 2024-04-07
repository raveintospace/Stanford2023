//
//  DismissXButton.swift
//  Memorize
//
//  Created by Uri on 7/4/24.
//

import SwiftUI

struct DismissXButton: View {
    
    @Environment(\.dismiss) var dismiss
    
    let customAction: (() -> Void)?
    
    var body: some View {
        Button(action: {
            customAction?() ?? dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

#Preview {
    DismissXButton(customAction: nil)
}
