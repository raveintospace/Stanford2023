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
        Text("Launch view")
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
