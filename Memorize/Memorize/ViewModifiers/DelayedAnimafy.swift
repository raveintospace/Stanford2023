//
//  DelayedAnimationModifier.swift
//  Memorize
//
//  Created by Uri on 20/5/24.
//

import SwiftUI

struct DelayedAnimafy: ViewModifier {
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
    func delayedAnimafy(delay: TimeInterval, duration: TimeInterval, action: @escaping () -> Void) -> some View {
        self.modifier(DelayedAnimafy(delay: delay, duration: duration, action: action))
    }
}
