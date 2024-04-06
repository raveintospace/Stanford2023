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
            return NSLocalizedString("Blue", comment: "")
        case .brown:
            return NSLocalizedString("Brown", comment: "")
        case .green:
            return NSLocalizedString("Green", comment: "")
        case .indigo:
            return NSLocalizedString("Indigo", comment: "")
        case .orange:
            return NSLocalizedString("Orange", comment: "")
        case .purple:
            return NSLocalizedString("Purple", comment: "")
        case .red:
            return NSLocalizedString("Red", comment: "")
        case .yellow:
            return NSLocalizedString("Yellow", comment: "")
        }
    }
}
