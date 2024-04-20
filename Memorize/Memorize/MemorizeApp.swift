//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Uri on 8/3/24.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = MemorojiViewModel()
    
    var body: some Scene {
        WindowGroup {
            MemorojiView(viewModel: game)
        }
    }
}
