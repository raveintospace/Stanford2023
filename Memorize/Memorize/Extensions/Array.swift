//
//  Array.swift
//  Memorize
//
//  Created by Uri on 11/3/24.
//

import Foundation

extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
