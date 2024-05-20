//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Uri on 8/3/24.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject private var game = MemorojiViewModel()
    @State private var showLaunchView: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if showLaunchView {
                LaunchView(showLaunchView: $showLaunchView)
                    .delayedAnimafy(delay: 3.5, duration: 0.3) {
                        showLaunchView = false
                    }
            } else {
                MemorojiView(viewModel: game)
            }
        }
    }
}
