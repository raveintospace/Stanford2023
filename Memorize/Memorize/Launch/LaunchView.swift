//
//  LaunchView.swift
//  Memorize
//
//  Created by Uri on 19/5/24.
//

import SwiftUI

struct LaunchView: View {
    
    @Binding var showLaunchView: Bool
    
    var body: some View {
        VStack {
            HStack {
                launchCard
                launchCard
            }
            HStack {
                launchCard
                launchCard
            }
            HStack {
                launchCard
                launchCard
            }
            HStack {
                launchCard
                launchCard
            }
        }
        .padding()
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                withAnimation(.easeOut(duration: 0.3)) {
                    showLaunchView = false
                }
            }
        }
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}

extension LaunchView {
    
    private var launchCard: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(.orange, lineWidth: 2)
            .fill()
            .foregroundStyle(Color.white)
            .overlay {
                Circle()
                    .foregroundStyle(Color.orange)
                    .opacity(0.8)
                    .padding(5)
                Text("M")
                    .font(.system(size: 50))
            }
            .frame(width: 100, height: 175)
            .padding(.horizontal, 10)
    }
}
