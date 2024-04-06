//
//  DeckColor.swift
//  Memorize
//
//  Created by Uri on 6/4/24.
//

import Foundation
import SwiftUI

enum CardColor: CaseIterable, CustomStringConvertible {
    
    case blue, green, orange, purple, red, yellow
    
    var color: Color {
        switch self {
        case .blue:
            return Color.blue
        case .green:
            return Color.green
        case .orange:
            return Color.orange
        case .purple:
            return Color.purple
        case .red:
            return Color.red
        case .yellow:
            return Color.yellow
        }
    }
    
    var description: String {
        switch self {
        case .blue:
            return "Blue"
        case .green:
            return "Green"
        case .orange:
            return "Orange"
        case .purple:
            return "Purple"
        case .red:
            return "Red"
        case .yellow:
            return "Yellow"
        }
    }
}
