//
//  ConfirmationRectangle.swift
//  Memorize
//
//  Created by Uri on 15/4/24.
//

import SwiftUI

struct ConfirmationRectangle: View {
    
    let copy: String
    let iconName: String
    
    var body: some View {
        Rectangle()
            .ignoresSafeArea()
            .frame(height: 75)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.green)
            .overlay(
                HStack(spacing: 2) {
                    Text(copy)
                    Image(systemName: iconName)
                }
                .foregroundStyle(Color.white)
                .bold()
                .font(.system(size: 18))
            )
    }
}

#Preview {
    ConfirmationRectangle(copy: "Score saved", iconName: "checkmark.seal")
}
