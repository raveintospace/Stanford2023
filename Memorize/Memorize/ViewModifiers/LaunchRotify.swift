//
//  LaunchRotify.swift
//  Memorize
//
//  Created by Uri on 20/5/24.
//

import SwiftUI

struct LaunchRotify: ViewModifier, Animatable {
    var rotation: Double
    
    var isFaceUp: Bool {
        rotation < 90 || rotation > 270
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(isFaceUp ? 1 : 0)  // Ensure content is visible only when face up before rotation
            .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
            .opacity(isFaceUp ? 1 : 0) // Ensure content is visible only when face up after rotation
    }
}

extension View {
    func rotify3D(isFaceUp: Bool) -> some View {
        modifier(LaunchRotify(rotation: isFaceUp ? 0 : 180))
    }
}
