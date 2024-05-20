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
            
        } else {
            portraitVStack
        }
    }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation(.easeOut(duration: 0.3)) {
                    showLaunchView = false
                }
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
    }
    
    private var createdByText: some View {
        Text("Created by Uri46")
            .foregroundStyle(Color.orange)
            .bold()
            .opacity(textOpacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        textOpacity = 1
                    }
                }
            }
    }
}
