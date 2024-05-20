//
//  DelayedAnimationModifier.swift
//  Memorize
//
//  Created by Uri on 20/5/24.
//

import SwiftUI

struct DelayedAnimationModifier: ViewModifier {
    let delay: TimeInterval
    let duration: TimeInterval
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.easeIn(duration: duration)) {
                        action()
                    }
                }
            }
    }
}

extension View {
    func delayedAnimation(delay: TimeInterval, duration: TimeInterval, action: @escaping () -> Void) -> some View {
        self.modifier(DelayedAnimationModifier(delay: delay, duration: duration, action: action))
    }
}
