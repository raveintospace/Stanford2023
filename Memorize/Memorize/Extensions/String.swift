//
//  String.swift
//  Memorize
//
//  Created by Uri on 20/4/24.
//

import Foundation

extension String {
    
    // removes any duplicate Characters
    // preserves the order of the Characters
    var uniqued: String {
        // not super efficient
        // would only want to use it on small(ish) strings
        // and we wouldn't want to call it in a tight loop or something
        reduce(into: "") { sofar, element in
            if !sofar.contains(element) {
                sofar.append(element)
            }
        }
    }
    
    mutating func remove(_ ch: Character) {
        removeAll(where: { $0 == ch })
    }
    
    func isEmoji() -> Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
                0x1F300...0x1F5FF, // Miscellaneous Symbols and Pictographs
                0x1F680...0x1F6FF, // Transport and Map Symbols
                0x1F1E6...0x1F1FF, // Regional indicator symbol letters
                0x2600...0x26FF,   // Misc symbols
                0x2700...0x27BF,   // Dingbats
                0xFE00...0xFE0F,   // Variation Selectors
                0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
                0x1F018...0x1F02F, // Hands
                0x0023...0x0039,   // Numbers
                0x200D:            // Zero Width Joiner
                return true
            default:
                continue
            }
        }
        return false
    }
}
