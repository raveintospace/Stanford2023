//
//  LaunchCard.swift
//  Memorize
//
//  Created by Uri on 19/5/24.
//

import SwiftUI

struct LaunchCard: View {
    let letter: String
    let startRotation: Double
    
    @State private var isFaceUp: Bool = false
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(.orange, lineWidth: 2)
            .fill()
            .foregroundStyle(isFaceUp ? Color.white : Color.orange)
            .overlay {
                if isFaceUp {
                    ZStack {
                        Circle()
                            .foregroundStyle(Color.orange)
                            .opacity(0.8)
                            .padding(5)
                        Text(letter)
                            .font(.system(size: 50))
                            .foregroundStyle(Color.white)
                    }
                }
            }
            .frame(width: 90, height: 157.5)
            .padding(10)
            .modifier(LaunchRotify(rotation: rotationAngle))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + startRotation) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        rotationAngle += 360
                        isFaceUp = true
                    }
                }
            }
    }
}

#Preview {
    HStack {
        LaunchCard(letter: "M", startRotation: 0.2)
        LaunchCard(letter: "E", startRotation: 0.4)
    }
    
}
