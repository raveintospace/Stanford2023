//
//  FlyingNumber.swift
//  Memorize
//
//  Created by Uri on 17/3/24.
//

import SwiftUI

struct FlyingNumber: View {
    
    let number: Int
    
    var body: some View {
        if number != 0 {
            Text(number, format: .number)
        }
    }
}

#Preview {
    FlyingNumber(number: 3)
}
