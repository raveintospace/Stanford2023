//
//  UIApplication.swift
//  Memorize
//
//  Created by Uri on 23/4/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    // dismiss keyboard
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
