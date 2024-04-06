//
//  DeckColor.swift
//  Memorize
//
//  Created by Uri on 6/4/24.
//

import Foundation
import SwiftUI

enum CardColor: CaseIterable, CustomStringConvertible {
    
    case blue, brown, green, indigo, orange, purple, red, yellow
    
    var color: Color {
        switch self {
        case .blue:
            return Color.blue
        case .brown:
            return Color.brown
        case .green:
            return Color.green
        case .indigo:
            return Color.indigo
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
        case .brown:
            return "Brown"
        case .green:
            return "Green"
        case .indigo:
            return "Indigo"
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
