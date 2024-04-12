//
//  DeckColor.swift
//  Memorize
//
//  Created by Uri on 6/4/24.
//

import Foundation
import SwiftUI

enum CardColor: CaseIterable, CustomStringConvertible {
    
    case blue, brown, gold, green, indigo, magenta, orange, purple, red, silver, uv, yellow
    
    var color: Color {
        switch self {
        case .blue:
            return Color.blue
        case .brown:
            return Color.brown
        case .gold:
            return Color.deckColor.gold
        case .green:
            return Color.green
        case .indigo:
            return Color.indigo
        case .magenta:
            return Color.deckColor.magenta
        case .orange:
            return Color.orange
        case .purple:
            return Color.purple
        case .red:
            return Color.red
        case .silver:
            return Color.deckColor.silver
        case .uv:
            return Color.deckColor.uv
        case .yellow:
            return Color.yellow
        }
    }
    
    var description: String {
        switch self {
        case .blue:
            return NSLocalizedString("Blue", comment: "")
        case .brown:
            return NSLocalizedString("Brown", comment: "")
        case .gold:
            return NSLocalizedString("Gold", comment: "")
        case .green:
            return NSLocalizedString("Green", comment: "")
        case .indigo:
            return NSLocalizedString("Indigo", comment: "")
        case .magenta:
            return NSLocalizedString("Magenta", comment: "")
        case .orange:
            return NSLocalizedString("Orange", comment: "")
        case .purple:
            return NSLocalizedString("Purple", comment: "")
        case .red:
            return NSLocalizedString("Red", comment: "")
        case .silver:
            return NSLocalizedString("Silver", comment: "")
        case .uv:
            return NSLocalizedString("UV", comment: "")
        case .yellow:
            return NSLocalizedString("Yellow", comment: "")
        }
    }
}
