//
//  LaunchView.swift
//  Memorize
//
//  Created by Uri on 19/5/24.
//

import SwiftUI

struct LaunchView: View {
    
    @Binding var showLaunchView: Bool
    
    @State private var textOpacity: Double = 0
    
    // detect landscape mode when presenting this view
    private var isLandscape: Bool {
        UIDevice.current.orientation.isLandscape
    }
    
    var body: some View {
        if isLandscape {
            landscapeVStack
        } else {
            portraitVStack
        }
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}

extension LaunchView {
    
    private var portraitVStack: some View {
        VStack {
            HStack {
                LaunchCard(letter: "M", startRotation: 0.5)
                LaunchCard(letter: "E", startRotation: 0.5)
            }
            HStack {
                LaunchCard(letter: "M", startRotation: 1)
                LaunchCard(letter: "O", startRotation: 1)
            }
            HStack {
                LaunchCard(letter: "R", startRotation: 1.5)
                LaunchCard(letter: "O", startRotation: 1.5)
            }
            HStack {
                LaunchCard(letter: "J", startRotation: 2)
                LaunchCard(letter: "I", startRotation: 2)
            }
            createdByText
        }
        .foregroundStyle(Color.orange)
        .padding(10)
        .aspectRatio(3/9, contentMode: .fit)
    }
    
    private var landscapeVStack: some View {
        VStack {
            HStack {
                LaunchCard(letter: "M", startRotation: 0.5)
                LaunchCard(letter: "E", startRotation: 0.5)
                LaunchCard(letter: "M", startRotation: 1)
                LaunchCard(letter: "O", startRotation: 1)
            }
            .padding(10)
            HStack {
                LaunchCard(letter: "R", startRotation: 1.5)
                LaunchCard(letter: "O", startRotation: 1.5)
                LaunchCard(letter: "J", startRotation: 2)
                LaunchCard(letter: "I", startRotation: 2)
            }
            .padding(10)
            createdByText
        }
        .foregroundStyle(Color.orange)
    }
    
    private var createdByText: some View {
        Text("Created by Uri46")
            .bold()
            .opacity(textOpacity)
            .delayedAnimafy(delay: 2.5, duration: 0.3) {
                textOpacity = 1.0
            }
    }
}
