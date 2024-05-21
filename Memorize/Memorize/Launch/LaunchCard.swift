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
    
    private struct Constants {
        static let inset: CGFloat = 5
        
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest / largest
        }
    }
    
    var body: some View {
        Circle()
            .opacity(0.8)
            .overlay {
                Text(letter)
                    .font(.system(size: Constants.FontSize.largest))
                    .minimumScaleFactor(Constants.FontSize.scaleFactor)
                    .multilineTextAlignment(.center)
                    .aspectRatio(4/3, contentMode: .fit)
                    .foregroundStyle(Color.white)
                    .padding(Constants.inset)
            }
            .padding(Constants.inset)
            .cardify(isFaceUp: isFaceUp)
            .transition(.scale)
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
