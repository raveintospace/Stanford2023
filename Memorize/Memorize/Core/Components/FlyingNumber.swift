//
//  FlyingNumber.swift
//  Memorize
//
//  Created by Uri on 17/3/24.
//

import SwiftUI

struct FlyingNumber: View {
    
    let number: Int
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        if number != 0 {
            Text(number, format: .number.sign(strategy: .always())) // show + or -
                .font(.largeTitle)
                .foregroundStyle(number < 0 ? Color.red : Color.green)
                .shadow(color: .black, radius: 1.5, x: 1, y: 1)
                .offset(x: 0, y: offset)
                .opacity(offset == 0 ? 1 : 0)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        offset = number < 0 ? 200 : -200
                    }
                }
                .onDisappear {
                    offset = 0
                }
        }
    }
}

#Preview {
    FlyingNumber(number: 3)
}
